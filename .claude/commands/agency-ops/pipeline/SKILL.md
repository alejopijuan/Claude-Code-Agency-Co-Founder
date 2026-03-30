---
name: agency-ops:pipeline
description: View and manage your deal pipeline with stage tracking and conversion metrics
argument-hint: "[add <deal-name> | move <deal-name> <stage> | status | metrics]"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Pipeline Tracker

I'll help you track deals through your pipeline, log stage transitions, and compute conversion metrics.

## Rules

1. Read `context/agency.md` first for agency identity and stage.
2. Read this skill's `learnings.md` BEFORE generating output; adapt based on any preferences or patterns found.
3. Parse `$ARGUMENTS` to determine the action:
   - `add <deal-name>` -- create a new deal file
   - `move <deal-name> <stage>` -- move a deal to a new stage
   - `status` -- show pipeline overview with all deals by stage
   - `metrics` -- show conversion metrics computed on the fly
   - No arguments -- show status overview (same as `status`)
4. Use AskUserQuestion for missing inputs, one question at a time, never batch.
5. Create `context/pipeline/` directory if it does not exist (use Bash `mkdir -p context/pipeline`).

## Pipeline Stages

Deals progress through 7 stages:

```
new-lead -> messaged -> replied -> call-booked -> discovery -> proposal -> closed
```

| Stage | Description | Advances when... |
|-------|-------------|------------------|
| new-lead | Just identified as a potential client | You send first outreach message |
| messaged | Outreach sent, awaiting response | Lead responds to your message |
| replied | Lead has responded | You book a call with them |
| call-booked | Discovery/intro call scheduled | Call happens |
| discovery | Had initial conversation, exploring fit | You send a proposal |
| proposal | Proposal sent, awaiting decision | They accept or decline |
| closed | Deal won or lost | -- |

## Add Deal Flow

When `$ARGUMENTS` starts with "add":

1. Extract the deal name from arguments (everything after "add").
2. Check if `context/pipeline/{lowercase-hyphenated-name}.md` already exists.
   - If it exists, tell the user: "Deal already exists. Use `/agency-ops:pipeline move {name} <stage>` to advance it."
3. If new, ask via AskUserQuestion (one at a time):
   1. "Who is the contact person?"
   2. "Is there an outreach lead file for this contact? If yes, what's their name in the outreach folder?" -- check if `context/outreach/{name}.md` exists. If it does, set `outreach_file` to the filename (without .md). If not found or user says no, set `outreach_file` to an empty string.
   3. "What's the estimated monthly value? (in dollars)"
   4. "What stage is this deal in?" -- show the 7 stages listed above. Default to `new-lead` if user skips.
4. Generate deal file at `context/pipeline/{lowercase-hyphenated-name}.md` using the template from `context/pipeline/_template.md`.
5. Initialize the Stage Transitions table with the first entry: `| {today} | -- | {stage} | Created |`

## Move Deal Flow

When `$ARGUMENTS` starts with "move":

1. Parse the deal name and target stage from arguments.
2. Read the existing deal file at `context/pipeline/{lowercase-hyphenated-name}.md`.
3. If the deal file doesn't exist, list available deals and ask the user to pick one.
4. Validate the target stage is one of the 7 valid stages.
5. If skipping stages (e.g., jumping from `new-lead` to `discovery`), warn the user but allow it: "You're skipping stages. This is fine, but your conversion metrics will reflect the gap."
6. Optionally ask: "Any notes for this transition?" (AskUserQuestion)
7. Update the deal file:
   - Append a new row to the Stage Transitions table: `| {today} | {current_stage} | {target_stage} | {notes or "Advanced"} |`
   - Update `stage` in YAML frontmatter to the new stage
   - Update `last_updated` to today's date
8. If `outreach_file` is set and the outreach lead file exists, also update the outreach lead file's `stage` frontmatter to match the new pipeline stage.
9. Confirm: "Moved {deal name} from {old stage} to {new stage}."

## Status Overview

When `$ARGUMENTS` is "status" or empty (no arguments):

1. Use Bash to list all files in `context/pipeline/` (excluding `_template.md`).
2. Read each deal file.
3. Display deals grouped by stage in a funnel view:

```
## Pipeline Status

**Total pipeline value:** ${total}/mo across {count} deals

### new-lead ({count})
- {Deal Name} -- ${value}/mo -- contact: {contact} -- created {date}

### messaged ({count})
- {Deal Name} -- ${value}/mo -- last moved {last_updated}

### replied ({count})
[... etc for each stage that has deals]

### closed ({count})
- {Deal Name} -- ${value}/mo -- closed {last_updated}
```

4. Show total pipeline value (sum of all non-closed deal values).
5. Show deal count per stage.
6. If a stage has no deals, skip it from the display.

## Metrics View

When `$ARGUMENTS` is "metrics":

Compute all metrics on the fly from deal files. Do NOT cache or store computed values.

1. Read all deal files in `context/pipeline/`.
2. For each deal, read the Stage Transitions table to determine which stages it has passed through.
3. Compute:
   - **Messages-to-replies ratio:** count of deals that reached "replied" / count that reached "messaged"
   - **Calls-to-close ratio:** count of deals at "closed" / count that reached "call-booked"
   - **Stage distribution:** count of deals currently at each stage
   - **Average time per stage:** for completed transitions (where a deal moved out of a stage), average the number of days between entering and leaving each stage
4. Display as a compact table:

```
| Metric | Value |
|--------|-------|
| Messages to replies | 60% (3/5) |
| Calls to close | 33% (1/3) |
| Total pipeline value | $4,250/mo |
| Active deals | 8 |
| Avg days in discovery | 5.2 days |
```

5. Show a stage funnel with counts:
```
new-lead(5) -> messaged(4) -> replied(3) -> call-booked(2) -> discovery(1) -> proposal(1) -> closed(1)
```

6. If fewer than 3 deals exist, show a note: "Metrics become more meaningful with more data. Keep adding deals!"

## Outreach Integration

Pipeline deals can link to outreach lead records for full context:

- When adding a deal, check `context/outreach/` for a matching lead file based on the contact name.
- Store the link in the `outreach_file` frontmatter field (filename without .md extension).
- When showing deal status or details, if `outreach_file` is set:
  - Read the outreach lead file at `context/outreach/{outreach_file}.md`
  - Include: source, channel used, total interactions logged
- Validate the outreach_file link exists before reading -- if the file was deleted or not found, show a warning: "Linked outreach file not found: {outreach_file}.md" but do not fail.

## Stage-Gated Adjustments

### Starting Out (0 clients)

- Explain the pipeline concept: "Your pipeline tracks every potential client from first contact to closed deal. Even with no clients yet, start adding leads as you do outreach."
- Encourage adding the first lead: "Run `/agency-ops:pipeline add {company-name}` to start tracking."
- Skip metrics display (not enough data to be meaningful).

### Getting Traction (1-3 clients)

- Standard pipeline view with all features.
- Include all metrics and stage details.
- Suggest: "Run `/agency-ops:outreach` to manage your outreach, then track promising leads here."

### Scaling (5+ clients)

- Focus on bottlenecks: highlight stages where deals have been stuck longest (more than 14 days without movement).
- Flag aging deals: any deal with `last_updated` older than 14 days gets an attention marker.
- Suggest follow-up actions for stuck deals: "Consider running `/agency-ops:outreach` to re-engage {deal}."
- Show velocity trends if enough data: compare this month's movement to last month.

## Empty State

If `context/pipeline/` does not exist or has no files besides `_template.md`:

> **No deals in your pipeline yet.** Run `/agency-ops:pipeline add {company-name}` to track your first deal.
>
> Your pipeline tracks leads through 7 stages from first contact to close. As you add outreach leads and move them through stages, you'll see conversion metrics and funnel analytics here.

## Learnings Update

After generating pipeline output:
1. Read this skill's `learnings.md` file.
2. If the user provides feedback or corrections (e.g., "I prefer to see values in the funnel", "Add a lost stage", "Skip the metrics for now"):
   - Append an entry with today's date and a relevant tag.
   - Place under **Preferences** (display format, stages, metrics) or **Situational** (deal-specific patterns, industry conversion benchmarks).
3. Check `max_entries` (30) -- if at the limit, move the oldest entry to **Pruned** or remove it.
4. Write the updated `learnings.md` back to disk.
