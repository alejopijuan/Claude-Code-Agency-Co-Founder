---
name: agency-ops:weekly-review
description: Cross-client summary with priorities, stale file flags, and forgotten commitment alerts
argument-hint: ""
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Weekly Review

Here's your cross-client operational summary for the week.

## Rules

1. Read `context/agency.md` first for agency identity and stage.
2. Read this skill's `learnings.md` BEFORE generating output; adapt based on any preferences or patterns found.
3. Use `Bash` to list all files in `context/clients/` (excluding `_template.md`).
4. Read EVERY client file found -- this is a cross-client summary. Do not skip any client files.
5. This skill is READ-ONLY on client files -- it does NOT modify them. The Write tool is only for updating this skill's `learnings.md`.
6. Flag stale files where today's date minus `last_updated` exceeds `staleness_threshold_days` (default 14 days if not specified in the client file).
7. Surface forgotten commitments: any commitment with Status "Pending" or "In Progress" where the Due date is in the past.
8. No arguments are needed -- this skill always reviews all clients.

## Output Format

Generate the following sections in order:

### Week Overview

- **Date range:** Monday through Sunday of the current week
- **Active clients:** total count of client files found
- **Overall health:** quick indicator based on how many clients are at risk vs healthy

### What Happened This Week

For each client with recent activity (`last_updated` within the last 7 days):

- **{Client Name}** -- 1-2 line summary of their most recent meeting notes or status changes from the past week

If no clients had activity this week, note: "No client activity recorded this week."

### What's Due This Week

All commitments across all clients with a Due date within the next 7 days, grouped by client:

**{Client Name}:**
- {Commitment} -- Owner: {owner}, Due: {date}, Status: {status}

If nothing is due this week, note: "No commitments due this week."

### At Risk

Flag items needing immediate attention in three categories:

**Stale clients:** Clients where `last_updated` exceeds their `staleness_threshold_days` value (default 14 days). For each stale client show:
- {Client Name} -- Last updated {date} ({N} days ago). Run `/agency-ops:client-briefing {name}` to review.

**Overdue commitments:** Commitments past their Due date with Status not "Done". For each show:
- {Client Name}: "{Commitment}" -- was due {date} ({N} days overdue), Owner: {owner}

**Forgotten commitments:** Commitments with Status "Pending" that are more than 7 days old with no recent meeting notes mentioning them. For each show:
- {Client Name}: "{Commitment}" -- created {date}, no recent follow-up

If nothing is at risk, note: "All clear -- no stale clients, overdue items, or forgotten commitments."

### Priorities

Suggested top 3-5 actions for the week, derived from the analysis above. Priority order:

1. Overdue items first (most overdue at the top)
2. Items due this week
3. Stale clients needing attention
4. Upcoming deadlines in the next 14 days

Each priority should be actionable: "Follow up with {client} on {commitment} -- {N} days overdue" or "Run `/agency-ops:follow-up {client}` to update stale file."

### Client Health Summary

Compact table summarizing all clients:

| Client | Status | Last Updated | Open Items | Health |
| ------ | ------ | ------------ | ---------- | ------ |
| {name} | {status from frontmatter} | {last_updated} | {count of non-Done commitments} | {health} |

Health values:
- **Good** -- updated recently (within staleness threshold), no overdue commitments
- **Attention** -- approaching staleness threshold (within 3 days) OR has items due within 3 days
- **At Risk** -- stale (past threshold) OR has overdue commitments

## Stage-Gated Adjustments

### Starting Out (0 clients)

If the agency stage is "starting" or "learning" and no client files exist:

> No clients yet! Your weekly review will become powerful once you add clients. Run `/agency-ops:new-client` to get started.

Skip the rest of the output sections -- this message is sufficient.

### Getting Traction (1-3 clients)

Standard output with all sections. Provide detailed per-client analysis since the user has a manageable number of clients and benefits from thorough review.

### Scaling (5+ clients)

More condensed per-client summaries -- focus on exceptions and risks rather than routine status. Add these additional metrics at the top of the output:

- **Total pipeline value:** sum of `monthly_value` across all active clients
- **Total overdue items:** count across all clients
- **Clients needing immediate attention:** list of clients with Health = "At Risk"

## Empty State

If no client files are found in `context/clients/` (only `_template.md` exists):

> No client files found. Run `/agency-ops:new-client` to add your first client. Your weekly review will come alive once you have active clients to track.

## Learnings Update

After generating the weekly review output:

1. Read `.claude/commands/agency-ops/weekly-review/learnings.md`
2. If the user provides feedback on the output (corrections, preferences, format changes), append a new entry to learnings.md
3. Entry format: `- [{category}] {learning} (from: weekly-review, {date})`
4. Categories: `Preference` (style/format choices), `Situational` (patterns observed across reviews), `Pruned` (outdated entries removed)
5. Check max_entries: if learnings.md exceeds 30 entries, prune the oldest `Situational` entries first, then oldest `Preference` entries
6. Additionally: if this skill identifies patterns across sessions (e.g., certain clients always go stale, certain commitment types always get forgotten), log these as `Situational` learnings for future reference
