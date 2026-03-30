---
name: agency-ops:follow-up
description: Process meeting notes into action items, draft follow-up email, and update client file
argument-hint: "<client-name>"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Follow-Up

I'll process your meeting notes into action items, draft a follow-up email, and update the client file.

## Rules

1. Read `context/agency.md` first for agency identity, communication style (tone, example phrases), and stage.
2. Read this skill's `learnings.md` BEFORE generating output; adapt based on any preferences or patterns found.
3. If `$ARGUMENTS` is provided, use it as the client name; otherwise use AskUserQuestion: "Which client was this meeting with?"
4. Read `context/clients/{client-name}.md` using the lowercase-hyphenated version of the client name.
5. If the client file does not exist, list available clients from `context/clients/` (excluding `_template.md`) and ask the user to pick one.
6. This skill WRITES BACK to the client file -- it is the ONLY skill that modifies client context files. All writes are append-only to the Commitments Log and Meeting Notes sections.
7. Never edit or delete existing rows in the Commitments Log -- only append new rows.
8. Use AskUserQuestion for each question individually, never batch multiple questions.

## Input Gathering

Ask the user for meeting details using AskUserQuestion, one question at a time:

1. **Meeting notes:** "Paste your meeting notes or tell me what happened in the meeting."
2. **Action items (if not clear from notes):** "Were there any specific action items or commitments made?"
3. **Timeline (if not clear from notes):** "What's the follow-up timeline? When should things be done?"

Also gather from context or ask if missing:
- Meeting type (check-in, review, kickoff, ad-hoc)
- Attendees
- Approximate duration

## Processing

After collecting meeting notes, process them as follows:

1. **Extract action items** from the notes. Look for indicators such as: "will do", "action:", "next steps", "committed to", promises, deadlines, tasks assigned, and any phrases that imply future work.
2. **Categorize each action by owner:**
   - "Us" -- the user's agency (from `agency_name` in `context/agency.md`)
   - Client name -- any task the client committed to
3. **Assign due dates** based on context:
   - Use explicit dates when mentioned in the notes
   - Default to 7 days from today if no date is specified
   - Adjust based on urgency language ("ASAP" = 2 days, "end of week" = next Friday, "next meeting" = look up meeting cadence)
4. **Identify status updates** to existing commitments in the client's Commitments Log:
   - If a previously pending item was discussed as completed, note it for a status update row
   - If an item was discussed as in progress, note the update
   - Status updates are appended as new rows (never edit original rows)

## Output Format

Present the processed results in these sections:

### Action Items

Bulleted list of all extracted actions:

- **[Owner]** -- [Action description] (Due: [date])
- **[Owner]** -- [Action description] (Due: [date])

### Draft Follow-Up Email

Generate a complete email draft that:

- Opens with a thank-you referencing the meeting (e.g., "Thanks for the time today" or "Great catching up this afternoon")
- Summarizes key discussion points in 2-3 concise bullets
- Lists all action items with owners and due dates in a clean format
- Closes with the next meeting date/time (pulled from the client file's Meeting Cadence section)
- Matches the agency's Communication Style from `context/agency.md` (tone, example phrases)
- Is formatted for easy copy-paste into an email client -- no markdown formatting that would look strange in email (use plain text bullets with dashes, no bold/italic markers)

Example format:

```
Subject: Follow-up: [Meeting Type] - [Date]

Hi [Contact Name],

Thanks for the time today during our [meeting type]. Here's a quick recap:

- [Discussion point 1]
- [Discussion point 2]
- [Discussion point 3]

Action items:
- [Us]: [Action] - by [date]
- [Client]: [Action] - by [date]

Our next check-in is [date/time from meeting cadence]. Let me know if anything comes up before then.

Best,
[Agency name]
```

### Client File Updates

Before writing to the client file, show the user exactly what will be appended:

**New Commitments Log entries:**
| Date | Commitment | Owner | Status | Due |
| ---- | ---------- | ----- | ------ | --- |
| [date] | [commitment] | [owner] | Pending | [due] |

**New Meeting Notes entry** (will be added at the top of Meeting Notes section):
```
### [date] -- [meeting type]
**Attendees:** [attendees]
**Duration:** [duration]
- [summary bullet 1]
- [summary bullet 2]
- **Action:** [key action items]
```

**Frontmatter update:** `last_updated` will be set to today's date.

## Client File Update

This is the CRITICAL write-back section. After showing the user what will be updated:

### Commitments Log

Append new rows to the existing Commitments Log table, matching the exact format:

```
| {date} | {commitment} | {owner} | {status} | {due} |
```

The table columns are: Date, Commitment, Owner, Status, Due.

- New entries get status "Pending" unless specified otherwise
- If an existing commitment's status changed (e.g., was discussed as completed), append a NEW row noting the status update rather than editing the original row. For example: `| 2026-04-01 | [Update] ROI report delivered to Dr. Chen | Us | Done | - |`
- Never remove or modify existing rows

### Meeting Notes

Append a new meeting notes entry at the TOP of the Meeting Notes section (most recent first), using the format:

```
### {date} -- {meeting type}
**Attendees:** {attendees}
**Duration:** {duration}
- {bullet points summarizing discussion}
- **Action:** {key action items}
```

### Frontmatter and Last Updated

- Update the `last_updated` field in the YAML frontmatter to today's date (YYYY-MM-DD format)
- Update the `## Last Updated` section at the bottom of the file to today's date

Use the Write tool to update the client file with all of these changes applied. Read the full client file first, apply the changes in memory, and write the complete updated file.

## Stage-Gated Adjustments

### Starting Out (0 clients)

- Use a simpler, warmer email tone -- less formal, more encouraging
- Include a tip: "Following up after meetings is one of the most important habits for building client trust. Even a short email shows professionalism."
- Skip conflict-checking with other clients (there are none)

### Getting Traction (1-3 clients)

- Standard output with all sections
- Include all action items, full email draft, complete client file updates
- Mention if the follow-up reveals potential upsell opportunities

### Scaling (5+ clients)

- More concise action items -- focus on what is new or changed
- Flag if this meeting's commitments conflict with deadlines from other client files (read other client files to check for scheduling conflicts)
- Add a "Capacity Check" note if total open commitments across all clients exceeds 10

## Empty State

If no client files are found in `context/clients/` (excluding `_template.md`):

> No client files found. You need to add a client before you can process follow-ups.
>
> Run `/agency-ops:new-client` to create your first client file.

## Learnings Update

After generating the follow-up output:

1. Read `.claude/commands/agency-ops/follow-up/learnings.md`
2. If the user provides feedback on the output (corrections, preferences, style notes), append a new entry to learnings.md
3. Entry format: `- [{category}] {learning} (from: {client}, {date})`
4. Categories: `Preference` (style/format choices), `Situational` (client-specific patterns), `Pruned` (outdated entries removed)
5. Check max_entries: if learnings.md exceeds 30 entries, prune the oldest `Situational` entries first, then oldest `Preference` entries
