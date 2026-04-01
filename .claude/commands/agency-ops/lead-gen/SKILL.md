---
name: agency-ops:lead-gen
description: Guide lead generation strategy selection for your niche
argument-hint: ""
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Lead Generation -- Strategy Guide

I'll help you develop a lead generation strategy for your niche. We'll figure out which approaches will work best for your stage and market, then create a plan to start filling your outreach pipeline.

## Rules

1. Read `context/agency.md` for niche, stage, target market.
2. Read this skill's `learnings.md` for accumulated preferences or patterns.
3. No client argument needed -- this skill finds NEW leads.
4. If outreach directory exists (`context/outreach/`), scan to understand current activity.
5. Do NOT proactively suggest scraping or Google Maps as a lead gen strategy. If the user specifically asks about scraping, THEN reference `templates/lead-gen/google-maps-scraping.md`.

## Stage 1: Strategy Assessment

Use `AskUserQuestion` for each question individually.

### Question 1: Current State

"Where are you with lead gen right now?"
- Haven't started yet
- Doing some outreach but want to be more systematic
- Have a pipeline but want to scale it
- Tried some things that didn't work (what?)

### Question 2: Target Niche

Confirm from agency.md or ask: "What niche are you targeting?"

### Question 3: Geographic Focus

"What city or region are you targeting?"

### Question 4: Goals

"How many new leads do you need per week?"
- 5-10 (starting, testing messaging)
- 10-25 (active outreach)
- 25-50 (scaling)

## Stage 2: Strategy Recommendation

Read `templates/lead-gen/lead-gen-strategy.md`.

Based on the assessment, recommend the strategy mix from the guide:
- Match to their stage (starting out, getting traction, scaling)
- Match to their niche (use niche-specific playbook from the guide if available)
- Prioritize by conversion rate and effort level

Present 2-3 recommended strategies with reasoning. Use the strategy selection framework from the guide to explain why these strategies fit their situation.

## Stage 3: Action Plan

For each recommended strategy, provide actionable next steps using `AskUserQuestion` to confirm priorities:

- **What to do this week** -- specific, concrete actions (not vague advice)
- **What tools or resources to set up** -- LinkedIn profile optimization, email templates, networking events calendar
- **How to track results** -- reference `/agency-ops:outreach` for tracking outreach activity
- **When to evaluate and adjust** -- set a review date (usually 2-4 weeks)

## Stage 4: Output

Show a summary strategy plan with:
- Recommended strategies ranked by priority
- Weekly action items for the first 2 weeks
- Metrics to track (leads generated, replies, calls booked)
- Review date to evaluate what's working

Offer to create a lead gen tracking file if the user wants one.

Reference: "Track your outreach with `/agency-ops:outreach` and pipeline with `/agency-ops:pipeline`."

## Stage-Gated Adjustments

- **Starting out (0 clients):** Focus on referrals + LinkedIn warm outreach. Your ONLY goal is closing your first client. Keep it simple -- 10-20 prospects, personal messages, no automation.
- **Getting traction (1-3 clients):** Add partnerships + content marketing. Leverage your existing client results as case studies. Expand to 2-3 outreach channels.
- **Scaling (5+ clients):** All strategies active. Optimize based on data. Consider cold email at volume. Track conversion rates across channels to double down on what works.

## Learnings Update

After completing the assessment, append a learning entry to `learnings.md`:

```markdown
- **[date]** [tag:lead-gen] [niche/city]: [strategies recommended, user feedback, adjustments]
```

Keep entries concise. Focus on niche-specific insights and which strategies resonated with the user.
