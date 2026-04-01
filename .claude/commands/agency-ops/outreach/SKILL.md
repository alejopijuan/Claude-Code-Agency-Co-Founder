---
name: agency-ops:outreach
description: Track and manage outreach across channels with message templates and follow-up reminders
argument-hint: "[add <lead-name> | status | follow-ups | templates | daily-check | methods]"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Outreach Tracker

I'll help you track outreach, log interactions, surface contacts needing follow-up, run daily check-ins on LinkedIn and Instagram via Playwright, and reference Sales Masterclass outreach methods. I manage per-lead files in `context/outreach/` with timestamped interaction logs and follow-up reminders based on a 3-5-7-14 day cadence.

## Rules

1. Read `context/agency.md` first for niche, communication style, and stage
2. Read this skill's `learnings.md` BEFORE generating output
3. Parse `$ARGUMENTS` to determine the action:
   - `add <lead-name>` -- create a new lead file or log an interaction to an existing lead
   - `status` -- show overview of all outreach leads with stages and follow-up status
   - `follow-ups` -- show only leads needing follow-up (next_follow_up is today or past)
   - `templates` -- show available message templates adapted to user's niche
   - `daily-check` -- use Playwright to check LinkedIn and Instagram for new replies
   - `methods` -- show the Sales Masterclass outreach methods framework
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
6. If fewer than 100 total messages have been sent across all leads, show progress toward the 100-message challenge:
   "100-Message Challenge: {count}/100 messages sent ({percent}%)"
   If complete: "100-Message Challenge: COMPLETE! Time to analyze your conversion funnel."
7. If there are leads with Status "Due", highlight them and suggest running `/agency-ops:outreach follow-ups` for details

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
3. Also read `.claude/commands/agency-ops/outreach/references/masterclass-message-templates.md` for the canonical Sales Masterclass templates
4. Display all templates with `{niche}` placeholders replaced with the user's actual niche from agency.md
5. Display both template sets: existing channel templates first, then masterclass templates section
6. Organize by channel: LinkedIn, Email, Phone, Instagram/WhatsApp
7. Highlight the LinkedIn second-connection strategy section

## Methods View

When `$ARGUMENTS` is "methods":

1. Read `.claude/commands/agency-ops/outreach/references/masterclass-outreach-methods.md`
2. Read `context/agency.md` for the user's stage and niche
3. Display the outreach funnel framework: 100 messages -> 30 responses -> 10 conversations -> 5 discovery calls -> 1-2 clients
4. Based on agency stage:
   - **Starting out**: Emphasize warm outreach sources first. Recommend the 100-message challenge. Start with one channel (LinkedIn recommended). Show all 5 warm sources with specific action steps.
   - **Getting traction**: Show both warm and cold methods. Highlight Loom + LinkedIn as the #1 cold method. Track conversion rates across channels.
   - **Scaling**: Focus on the cold methods table with difficulty/conversion rankings. Recommend diversifying across 2-3 channels. Flag in-person/conferences as highest-conversion.
5. Show the 5 Dimensions of Your Edge for strategic context
6. Offer to help plan a specific outreach campaign: "Want me to help you plan a {warm/cold} outreach campaign for your niche?"

## Daily Check Flow

When `$ARGUMENTS` is "daily-check":

1. Announce: "Starting daily outreach check. I'll open LinkedIn and Instagram to check for new replies."

2. **LinkedIn check:**
   - Use Playwright MCP: `browser_navigate` to `https://www.linkedin.com/messaging/`
   - `browser_snapshot` to capture current state
   - If not logged in, tell the user: "Please log in to LinkedIn in the Playwright browser window. Let me know when you're ready."
   - Once logged in, identify unread conversations (look for unread indicators, bold text, notification badges)
   - For each unread conversation:
     - Click to open the thread
     - `browser_snapshot` to capture the full conversation
     - Extract the contact name and latest message content
   - Add human-like delays between actions (2-5 seconds between clicks) to avoid detection
   - Limit to checking the 10 most recent unread conversations per session

3. **Instagram check:**
   - Use Playwright MCP: `browser_navigate` to `https://www.instagram.com/direct/inbox/`
   - `browser_snapshot` to capture current state
   - If not logged in, tell the user: "Please log in to Instagram in the Playwright browser window. Let me know when you're ready."
   - Once logged in, identify unread conversations
   - For each unread conversation:
     - Click to open the thread
     - `browser_snapshot` to capture the conversation
     - Extract contact name and latest message content
   - Same human-like delays as LinkedIn

4. **Process replies:**
   For each new reply found across both platforms:
   - Search for matching lead file in `context/outreach/` by contact name
   - **If matched:** Read the lead file, update stage if appropriate (e.g., messaged -> replied), log the new interaction, draft a reply
   - **If not matched:** Ask the user: "Found a reply from {name} on {platform}. Want me to create a new lead file for them?"

5. **Draft reply messages:**
   For each reply that needs a response:
   - Read `context/agency.md` for communication style and niche
   - Read this skill's `learnings.md` for tone preferences and past modifications
   - Read `.claude/commands/agency-ops/outreach/references/masterclass-message-templates.md` for base style
   - Draft a personalized reply that:
     - Matches the conversation context and stage
     - Uses the masterclass message tone as a baseline
     - Adapts to the user's learned preferences from learnings.md
   - Present each draft clearly formatted for copy-paste:
     ```
     ---
     **Reply to {name} on {platform}:**

     {draft message}

     ---
     ```
   - **CRITICAL: Never auto-send.** The user copies and pastes manually. This is intentional to avoid AI detection and maintain authentic feel.

6. **Update files and sync:**
   - Update matched lead files with new interaction log entries
   - Update `last_contact` and recalculate `next_follow_up` per the standard cadence
   - Dual-write to Supabase (follow existing Supabase Sync pattern at bottom of this skill)

7. **Summary:**
   Show a completion summary:
   ```
   Daily check complete:
   - LinkedIn: {X} new replies found
   - Instagram: {Y} new replies found
   - Lead files updated: {Z}
   - Follow-up drafts ready: {N}

   Next daily check: run `/agency-ops:outreach daily-check` tomorrow
   Tip: Use `/loop 24h /agency-ops:outreach daily-check` for automatic daily runs
   ```

### Rate Limiting and Safety

- Add 2-5 second delays between page navigations and clicks (use random jitter)
- Limit total session to 5 minutes per platform (10 minutes total)
- If a CAPTCHA or unusual challenge appears, stop immediately and inform the user
- If the browser session expires, prompt the user to re-authenticate
- Do not scroll excessively or rapidly -- mimic natural browsing patterns

## Stage-Gated Adjustments

Read the `stage` field from `context/agency.md` and adjust behavior accordingly.

### Starting Out (0 clients)

- Focus on building the first outreach list
- Encourage consistency: "Outreach is a numbers game -- aim for 5 new leads this week"
- Suggest starting with 5 leads before worrying about follow-up systems
- Recommend starting with one channel (LinkedIn is usually easiest)
- Reference the Sales Masterclass warm outreach sources: "The masterclass recommends starting with your LinkedIn 2nd connections and phone contacts -- people you already know"
- Encourage the 100-message challenge: "Send 100 messages over 5 days (20/day). Most people stop at 10 -- that doesn't count."
- Run `/agency-ops:outreach methods` for the full masterclass framework
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
