---
name: agency-ops:outreach
description: Track and manage outreach across channels with message templates and follow-up reminders
argument-hint: "[add <lead-name> | status | follow-ups | templates]"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Outreach Tracker

I'll help you track outreach, log interactions, and surface contacts needing follow-up. I manage per-lead files in `context/outreach/` with timestamped interaction logs and follow-up reminders based on a 3-5-7-14 day cadence.

## Rules

1. Read `context/agency.md` first for niche, communication style, and stage
2. Read this skill's `learnings.md` BEFORE generating output
3. Parse `$ARGUMENTS` to determine the action:
   - `add <lead-name>` -- create a new lead file or log an interaction to an existing lead
   - `status` -- show overview of all outreach leads with stages and follow-up status
   - `follow-ups` -- show only leads needing follow-up (next_follow_up is today or past)
   - `templates` -- show available message templates adapted to user's niche
   - No arguments -- show status overview (same as `status`)
4. If adding a lead, use AskUserQuestion for required fields not provided
5. Use AskUserQuestion for each question individually, never batch
6. Create `context/outreach/` directory if it does not exist (use Bash `mkdir -p`)

## Add Lead Flow

When `$ARGUMENTS` starts with "add":

1. Extract lead name from arguments (everything after "add")
2. Generate filename: lowercase, hyphenated version of the name (e.g., "Dr. Sarah Chen" becomes `dr-sarah-chen.md`)
3. Check if `context/outreach/{lowercase-hyphenated-name}.md` already exists

**If lead file exists:** Jump to the Log Interaction Flow below to append a new interaction.

**If new lead:** Ask these questions via AskUserQuestion (one at a time):

1. "What company is {name} with?"
2. "What channel did you reach out on?" -- offer options: LinkedIn, Instagram, WhatsApp, email, phone
3. "How did you find this lead?" -- offer options: Google Maps scrape, referral, LinkedIn search, cold email list, other
4. "What message did you send or what happened?" (for the first interaction log entry)

Then generate the lead file at `context/outreach/{lowercase-hyphenated-name}.md` using the template format from `context/outreach/_template.md`:

- Replace all `{{variable}}` placeholders with actual values
- Set `stage` based on channel and interaction type:
  - If a message was sent: `messaged`
  - If a connection request was sent (LinkedIn): `new-lead`
  - If they were just identified/scraped: `new-lead`
- Set `last_contact` to today's date (ISO 8601)
- Set `next_follow_up` to 3 days from today (first step in the 3-5-7-14 cadence)

## Log Interaction Flow

When adding to an existing lead:

1. Read the existing lead file
2. Ask via AskUserQuestion (one at a time):
   - "What channel was this interaction on?" -- options: LinkedIn, Instagram, WhatsApp, email, phone
   - "What type of interaction?" -- options: Cold outreach, Follow-up, Reply, Call
   - "What happened? Describe the interaction."
   - "Did they respond? If so, what did they say?" (default: "Pending")
3. Append a new timestamped entry to the Interaction Log section:

```
### {today's date} -- {brief description}
- **Channel:** {channel}
- **Type:** {Cold outreach | Follow-up | Reply | Call}
- **Message:** {content}
- **Response:** {response or "Pending"}
```

4. Update `last_contact` in YAML frontmatter to today's date
5. Recalculate `next_follow_up` based on the 3-5-7-14 cadence:
   - Count existing interaction log entries (### headings in the Interaction Log section)
   - 1 prior entry (this is 1st follow-up): set next_follow_up to today + 3 days
   - 2 prior entries (2nd follow-up): set next_follow_up to today + 5 days
   - 3 prior entries (3rd follow-up): set next_follow_up to today + 7 days
   - 4+ prior entries (subsequent follow-ups): set next_follow_up to today + 14 days
6. Update `stage` if appropriate:
   - If they replied, move from "messaged" to "replied"
   - If a call was booked, move to "call-booked"
   - If a discovery call happened, move to "discovery"
   - If a proposal was sent, move to "proposal"
   - If they signed, move to "closed"

## Status Overview

When `$ARGUMENTS` is "status" or empty (no arguments):

1. Use Bash to list all files in `context/outreach/` (excluding `_template.md`)
2. Read each lead file's YAML frontmatter
3. Display a compact summary table:

```
| Lead | Company | Channel | Stage | Last Contact | Next Follow-Up | Status |
|------|---------|---------|-------|--------------|----------------|--------|
```

Where Status is:
- **Due** -- next_follow_up is today or in the past (needs attention)
- **OK** -- next_follow_up is in the future (on track)
- **Stale** -- last_contact was more than 14 days ago with no recent activity

4. Show stage distribution: count of leads at each stage (e.g., "messaged: 3, replied: 1, call-booked: 1")
5. Show channel distribution: count of leads per channel (e.g., "LinkedIn: 4, email: 2, phone: 1")
6. If there are leads with Status "Due", highlight them and suggest running `/agency-ops:outreach follow-ups` for details

## Follow-Up View

When `$ARGUMENTS` is "follow-ups":

1. Read all lead files in `context/outreach/` (excluding `_template.md`)
2. Show ONLY leads where `next_follow_up` is today or in the past
3. For each lead needing follow-up, show:
   - Lead name and company
   - Last interaction summary (most recent entry in Interaction Log)
   - Days since last contact
   - Suggested next action based on position in cadence and channel
   - Suggested message from templates (adapted to niche from agency.md)
4. If no follow-ups are due, show: "All caught up! No follow-ups due today."

## Templates View

When `$ARGUMENTS` is "templates":

1. Read `context/agency.md` for the user's niche
2. Read `.claude/commands/agency-ops/outreach/references/message-templates.md`
3. Display all templates with `{niche}` placeholders replaced with the user's actual niche from agency.md
4. Organize by channel: LinkedIn, Email, Phone, Instagram/WhatsApp
5. Highlight the LinkedIn second-connection strategy section

## Stage-Gated Adjustments

Read the `stage` field from `context/agency.md` and adjust behavior accordingly.

### Starting Out (0 clients)

- Focus on building the first outreach list
- Encourage consistency: "Outreach is a numbers game -- aim for 5 new leads this week"
- Suggest starting with 5 leads before worrying about follow-up systems
- Recommend starting with one channel (LinkedIn is usually easiest)
- Provide extra coaching on message personalization

### Getting Traction (1-3 clients)

- Standard tracking with all features
- Suggest diversifying channels: "You're doing well on LinkedIn. Have you tried email outreach too?"
- Encourage referral-based outreach from existing clients
- Track conversion rates across channels

### Scaling (5+ clients)

- Focus on pipeline conversion metrics
- Flag leads that have been in "messaged" stage for 14+ days (going cold)
- Suggest batch outreach strategies
- Prioritize high-value leads based on company size or industry fit
- Recommend delegating initial outreach if volume is high

## Empty State

If `context/outreach/` directory is empty or does not exist:

"No outreach leads tracked yet. Run `/agency-ops:outreach add {lead-name}` to start tracking your first lead.

**Quick start:**
1. `/agency-ops:outreach add Dr. Sarah Chen` -- add your first lead
2. `/agency-ops:outreach status` -- see your outreach dashboard
3. `/agency-ops:outreach follow-ups` -- see who needs attention
4. `/agency-ops:outreach templates` -- get message templates for your niche"

## Learnings Update

After completing any outreach action, check if there are useful patterns to record:
- Read `.claude/commands/agency-ops/outreach/learnings.md`
- If the user expressed a preference (channel preference, message tone, follow-up timing), add it to the Preferences section
- If a situational insight emerged (what works for their niche, best times to reach out), add it to the Situational section
- Keep total entries under 30 (prune oldest Situational entries if needed)
- Write updated learnings.md back

## Supabase Sync

After completing all file writes and learnings updates above:

1. Read the `supabase_url` and `supabase_anon_key` fields from the `context/agency.md` YAML frontmatter (already read at step 1 of Rules).
2. If either field is missing, empty, or contains `{{`, skip this section entirely. The skill is complete.
3. If both are present, construct a JSON object from the lead file's YAML frontmatter fields: name, company, channel, stage, source, last_contact, next_follow_up.
4. Use Bash to execute:
   ```
   curl -s -L -X POST "{supabase_url}/rest/v1/leads" \
     -H "apikey: {supabase_anon_key}" \
     -H "Authorization: Bearer {supabase_anon_key}" \
     -H "Content-Type: application/json" \
     -H "Prefer: resolution=merge-duplicates" \
     -d '{json_object}'
   ```
5. If the curl fails or returns an error response, show a brief note: "Dashboard sync skipped -- your outreach data is saved in markdown." Continue normally. Do NOT retry.

Refer to `.claude/commands/agency-ops/setup-dashboard/references/dual-write-guide.md` for full details on the Supabase sync pattern.
