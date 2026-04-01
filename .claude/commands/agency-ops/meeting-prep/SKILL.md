---
name: agency-ops:meeting-prep
description: Generate a structured meeting agenda with open tasks, follow-ups, and questions to ask
argument-hint: "<client-name>"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Meeting Prep

I'll generate a structured agenda for your upcoming client meeting.

## Rules

1. Read `context/agency.md` first for agency identity, niche, communication style, and stage.
2. Read this skill's `learnings.md` BEFORE generating output; adapt based on any preferences or patterns found.
3. If `$ARGUMENTS` is provided, use it as the client name; otherwise use AskUserQuestion to ask "Which client are you preparing for?"
4. Read `context/clients/{client-name}/{client-name}.md` using the lowercase-hyphenated version of the client name.
5. If client file does not exist, list subdirectories in `context/clients/` (excluding files like `_template.md`) using `ls -d context/clients/*/` and ask the user to pick one.
6. Output must be a numbered agenda -- structured, scannable, ready to use in a meeting.
7. Use AskUserQuestion for each question individually, never batch.

## SOP References

Before generating the agenda, read these SOPs for protocol context:
- Read `context/sops/meeting-protocol.md` -- use the Agenda Structure (Section 2) to inform agenda item ordering and time allocations. Reference the Meeting Types (Section 5) to adjust depth based on meeting type.

## Input Gathering

After reading the client file, optionally ask:

1. Use AskUserQuestion: "Is there anything specific you want to cover in this meeting?"
   - If user says "no" or skips, proceed with defaults from client file
2. Use AskUserQuestion: "What type of meeting is this?" with options: Regular check-in, Monthly review, Discovery/scoping, Ad-hoc/urgent
   - If user skips, default to the type that matches the client's meeting cadence

Both questions are optional -- if the user says "no" or skips, proceed with defaults derived from the client file.

## Output Format

Generate the agenda with these exact sections:

### Meeting Header

- **Client:** {client name}
- **Meeting Type:** {type from Input Gathering or default}
- **Date:** today's date
- **Attendees:** {from Key Contacts section in client file}
- **Meeting Cadence:** {from Meeting Cadence section -- e.g., "Biweekly check-ins"}

### Agenda

Numbered items, each with a suggested time allocation:

1. **Quick check-in / rapport** (2 min) -- brief personal check-in to build relationship
2. **Status updates on active projects** (5-10 min) -- review each item from the Active Projects section with current status (done, in progress, not started)
3. **Open commitments review** (5 min) -- list all non-Done commitments from the Commitments Log with status and due dates. Highlight any overdue items with a warning marker.
4. **Follow-up items from last meeting** (5 min) -- extract action items and discussion points from the most recent Meeting Notes entry. Note what was completed and what is still open.
5. **Custom topics** (5-10 min) -- if the user provided specific topics in Input Gathering, include them here with suggested discussion framing. Skip this item if no custom topics were provided.
6. **Questions to ask** (5 min) -- generate 3-5 questions based on:
   - Gaps in the client file (missing information, unclear project status)
   - Upcoming deadlines within the next 14 days
   - Stale items that haven't been updated
   - Project next steps that need client input
   - Potential upsell or expansion opportunities based on current engagement
7. **Next steps and action items** (3 min) -- placeholder for capturing decisions and commitments during the meeting. Remind the user to run `/agency-ops:follow-up {client}` after the meeting.

### Pre-Meeting Checklist

Things to prepare or review before the meeting:

- [ ] Review last meeting notes ({date of most recent Meeting Notes entry} -- {brief summary})
- [ ] Check if any commitments are overdue ({count} overdue items, or "none")
- [ ] Prepare any deliverables due before this meeting (list specific items if found)
- [ ] Review communication style notes for this client (from Communication Preferences section)
- [ ] Open the client's project dashboard or tool if applicable

## Stage-Gated Adjustments

Adjust the agenda depth based on the `stage` field from `context/agency.md`:

### Starting Out (0 clients)

- Simpler agenda with fewer items -- focus on relationship building and discovery
- If no client files exist, suggest running `/agency-ops:new-client` first
- Include a tip: "For early meetings, focus on listening more than presenting. Ask about their pain points and current phone handling workflow."
- Skip cross-client context (not relevant yet)

### Getting Traction (1-3 clients)

- Standard agenda with all sections as described above
- Include all agenda items and the full Pre-Meeting Checklist
- Balanced depth -- detailed enough to be useful, concise enough to scan quickly

### Scaling (5+ clients)

- Include cross-client context: mention if other client deadlines conflict with action items that might come out of this meeting
- More structured time allocations to keep meetings efficient
- Add a "Context Switch" note at the top: brief reminder of where things stand if the user has been focused on other clients
- Flag if this client's meeting cadence has been missed (no meeting notes within the expected cadence period)

## Empty State

If the requested client file doesn't exist, or if `context/clients/` has no files besides `_template.md`:

> **No client files found.** Run `/agency-ops:new-client` to create your first client.
>
> Once you have a client file, run `/agency-ops:meeting-prep <client-name>` to generate a meeting agenda.

If the specific client wasn't found but other clients exist, list available clients and ask the user to pick one.

## Learnings Update

After generating the agenda:
1. Read this skill's `learnings.md` file
2. If the user provides feedback or corrections during this session (e.g., "I prefer shorter agendas", "Always include pricing discussion", "Skip the rapport section"):
   - Append an entry with today's date and a relevant tag
   - Place under the appropriate category: **Preferences** (agenda format, sections to include/skip, time allocations) or **Situational** (client-specific meeting patterns, industry nuances)
3. Check `max_entries` (30) -- if at the limit, move the oldest entry to **Pruned** or remove it
4. Write the updated `learnings.md` back to disk
