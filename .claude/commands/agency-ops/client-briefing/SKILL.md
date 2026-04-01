---
name: agency-ops:client-briefing
description: Generate a comprehensive briefing for a specific client before meetings or context-switching
argument-hint: "<client-name>"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Client Briefing

I'll generate a compact briefing for your client so you're prepared for any interaction.

## Rules

1. Read `context/agency.md` first for agency identity, niche, communication style, and stage.
2. Read this skill's `learnings.md` BEFORE generating output; adapt based on any preferences or patterns found.
3. If `$ARGUMENTS` is provided, use it as the client name; otherwise use AskUserQuestion to ask "Which client do you want a briefing for?"
4. Read `context/clients/{client-name}/{client-name}.md` using the lowercase-hyphenated version of the client name.
5. If client file does not exist, list subdirectories in `context/clients/` (excluding files like `_template.md`) using `ls -d context/clients/*/` and ask the user to pick one.
6. Output must be compact -- key data highlighted, not walls of text.
7. Use AskUserQuestion for each question individually, never batch.

## Output Format

Generate a briefing with these exact sections:

### Status Snapshot

- **Client:** {client name}
- **Industry:** {industry}
- **Status:** {status from frontmatter}
- **Monthly Value:** ${monthly_value}/mo
- **Last Updated:** {last_updated from frontmatter}
- **Staleness Warning:** If `last_updated` is older than `staleness_threshold_days` from today, show a warning: "This client file hasn't been updated in {N} days. Consider reviewing and updating after your next interaction."

### Project Overview

- List all items from the Active Projects section with their current status (done, in progress, not started)
- Note the voice AI platform and primary use case from Project Scope
- Highlight any projects that have changed status since the last meeting

### Open Commitments

Display a table of all non-Done commitments from the Commitments Log:

| Date | Commitment | Owner | Status | Due |
|------|------------|-------|--------|-----|

- Mark any past-due items with a warning indicator
- Sort by due date (soonest first)
- If all commitments are Done, note "All commitments fulfilled -- nice work!"

### Key Contacts

List each contact with:
- Name and role
- Email
- Communication preferences or style notes (from Communication Preferences section)
- Note escalation paths if documented

### Talking Points

Generate 3-5 talking points derived from:
- Recent meeting notes (action items, follow-ups mentioned)
- Open commitments nearing their due date
- Stale items that haven't been updated
- Active project status changes or milestones
- Any upcoming deadlines within the next 7 days

Each talking point should be a concrete, actionable conversation starter -- not generic filler.

### Recent Activity

Summarize the last 2 entries from the Meeting Notes section:
- Date and attendees
- 1-2 line summary of key discussion points and outcomes
- Any action items that came out of the meeting

## Stage-Gated Adjustments

Adjust the briefing depth based on the `stage` field from `context/agency.md`:

### Starting Out (0 clients)

- Lighter output -- skip metrics and trend analysis
- Use an encouraging, supportive tone
- If no client files exist (only `_template.md` in `context/clients/`), suggest running `/agency-ops:new-client` to create their first client
- Focus on relationship building talking points rather than operational details

### Getting Traction (1-3 clients)

- Standard output with all sections as described above
- Include all metrics and commitment tracking
- Balanced tone -- professional and action-oriented

### Scaling (5+ clients)

- Add trend indicators to Status Snapshot: is this client growing (expanding scope), stable (steady engagement), or at-risk (stale file, overdue commitments, no recent meetings)?
- Cross-reference other client files in `context/clients/` to flag commitment conflicts (e.g., "You also have a deliverable due for {other client} on the same day")
- More concise output -- operators at this stage need speed, not hand-holding

## Empty State

If the requested client file doesn't exist, or if `context/clients/` has no files besides `_template.md`:

> **No client files found.** Run `/agency-ops:new-client` to create your first client.
>
> Once you have a client file, run `/agency-ops:client-briefing <client-name>` to get a full briefing.

If the specific client wasn't found but other clients exist, list available clients and ask the user to pick one.

## Learnings Update

After generating the briefing:
1. Read this skill's `learnings.md` file
2. If the user provides feedback or corrections during this session (e.g., "I prefer shorter briefings", "Always include the monthly value", "Skip the talking points"):
   - Append an entry with today's date and a relevant tag
   - Place under the appropriate category: **Preferences** (output format, tone, sections to include/skip) or **Situational** (client-specific patterns, industry nuances)
3. Check `max_entries` (30) -- if at the limit, move the oldest entry to **Pruned** or remove it
4. Write the updated `learnings.md` back to disk
