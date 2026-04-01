---
name: agency-ops:onboarding
description: Stage-gated agency setup wizard -- run this first to personalize your toolkit
argument-hint: "[--reset]"
disable-model-invocation: true
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Agency Ops Hub -- Onboarding

Welcome to Agency Ops Hub! I'll set up your personalized voice AI agency toolkit through a quick conversation. This takes about 3 minutes -- and you can stop at any point. Whatever you share, I'll generate your agency profile immediately.

## Rules

1. Be conversational, not interrogative. This should feel like filling out a profile, not configuring a system.
2. First useful output within 3 minutes. After 2-3 questions, generate `context/agency.md` immediately with sensible defaults for everything else.
3. If the user wants to stop at any point, generate what you can with defaults for missing fields. Never leave them without a working setup.
4. Never block access to other skills based on onboarding completion. All skills work with partial context.
5. Use `AskUserQuestion` for each question individually -- do not batch multiple questions.
6. If `$ARGUMENTS` contains `--reset`, follow the Reset Flow below instead.

## Reset Flow

If `--reset` is passed:
1. Read existing `context/agency.md`
2. Show current values in a summary
3. Ask what the user wants to change
4. Update incrementally using `Write` rather than re-running the full flow
5. Confirm changes and show the updated profile

## Stage 1: Journey Check (REQUIRED)

Ask the user: "Where are you in your voice AI agency journey?"

Present these options:
- **Starting out (0 clients)** -- Learning, exploring niches, building first demos
- **Getting traction (1-3 clients)** -- Landed first clients, actively delivering
- **Scaling (5+ clients)** -- Growing the business, need better operations

This answer determines the depth of subsequent questions.

## Stage 2: Core Identity (3-4 questions, then GENERATE)

Ask about:
1. **Agency name** -- What's your agency called? (If starting out, suggest they pick a working name -- they can always change it later with `--reset`)
2. **Core offering** -- What's the core of your business? Present options:
   - **Voice AI systems** -- Speed-to-lead, after-hours inbound, database reactivation
   - **Broader AI automation** -- Voice + workflows, n8n systems, chatbots, integrations
   - **AI consulting / audits** -- Process audits, AI readiness assessments, implementation roadmaps
   - **Still figuring it out** -- Exploring what resonates
3. **Niche focus** -- What industries are you targeting? Common niches: dental, roofing, med spa, law firms, HVAC, or "exploring multiple"

After receiving these two answers, IMMEDIATELY use the `Write` tool to generate `context/agency.md` with the user's answers and sensible defaults for all remaining fields. Show the user a brief summary of what was created:
- Agency name and niche
- What defaults were applied
- That they can continue to customize or stop here

## Stage 3: Deeper Context (OPTIONAL)

Ask the user if they'd like to continue customizing. If yes, ask one at a time:
- **Services offered** -- What do you build for clients? (voice agents, automation systems, both?)
- **Pricing approach** -- How do you charge? (project-based, monthly retainer, exploring?)
- **Tech stack** -- Which voice AI platform? (Retell, Vapi, ElevenLabs, or not yet decided?) Which CRM? (GoHighLevel, HubSpot, none yet?) Any automation tools? (n8n, Make, Zapier?)
- **Team size** -- Solo operator, small team, or growing team?
- **Communication style** -- How do you talk to clients? (Professional, casual, technical?) Any go-to phrases?

Update `context/agency.md` after each answer using the `Write` tool.

## Stage 4: Tracking Preferences (OPTIONAL)

Present tracking options for how they want to manage outreach and follow-ups:
- **Manual tracking in markdown files** -- Simplest approach, works right now
- **Playwright-based LinkedIn DM checking** -- Automated monitoring (coming in v2)
- **Email polling** -- Automated inbox scanning (coming in v2)
- **CRM webhooks** -- Real-time sync from GoHighLevel/HubSpot (coming in v2)

Capture their choice in `context/agency.md` under the Tracking Approach section. If they pick a v2 option, note it as their preferred future approach and default to manual tracking for now.

## Stage 5: Wrap Up

1. Verify `context/clients/_template.md` exists (should already be there from setup). If missing, note it but do not create -- it is a setup issue.
2. Verify `context/clients/_example-sunrise-dental/sunrise-dental.md` exists as the example client file.
3. Show a final summary:
   - Files created or verified
   - List of available skills (reference the Skill Registry in CLAUDE.md)
   - Suggested next steps:
     - "Run `/agency-ops:new-client` to add your first client"
     - "Run `/agency-ops:client-briefing <client-name>` to see a client summary"
     - "Check out the Skill Registry in CLAUDE.md for everything available"

## Stage-Gated Adjustments

Adjust your approach based on the journey stage from Stage 1:

### Starting Out (0 clients)
- Skip services pricing details -- default to "exploring"
- Suggest niche exploration rather than locking in
- Use a lighter, more encouraging tone
- Emphasize that everything can be changed later
- Skip Stage 4 (tracking) unless they ask -- default to manual

### Getting Traction (1-3 clients)
- Ask about existing clients -- offer to create their first client file right after onboarding
- Ask about current pain points (keeping track of commitments, meeting prep, follow-ups)
- Suggest specific skills based on their pain points

### Scaling (5+ clients)
- Ask about specific pain points (which operations are breaking?)
- Get CRM details -- they likely have one
- Ask about pipeline structure and team roles
- Explore tracking preferences in more depth -- they need automation

## Defaults for Skipped Questions

When generating `context/agency.md`, use these defaults for any field the user hasn't answered:

| Field | Default |
|-------|---------|
| agency_name | "My Voice AI Agency" |
| core_offering | "Voice AI systems" |
| niche | "exploring" |
| stage | "starting-out" |
| services | "Voice AI solutions" |
| pricing | "Project-based, exploring retainer model" |
| tech_stack.voice_platform | "Not yet decided" |
| tech_stack.crm | "None yet" |
| tech_stack.automation | "None yet" |
| tech_stack.communication | "Email" |
| team_size | "Solo operator" |
| communication_style.tone | "Professional and friendly" |
| communication_style.examples | "Here's what I'm seeing..., Let me walk you through..." |
| tracking_approach | "Manual tracking" |

## agency.md Generation Instructions

When writing `context/agency.md`:
1. Replace all `{{variable}}` placeholders with actual values from user answers or from the defaults table above
2. The generated file must NOT contain any `{{}}` template variables -- it must be fully populated with real values
3. Follow the exact section structure from the existing `context/agency.md` template (Identity, Services, Team, Tech Stack, Communication Style, Tracking Approach, Clients Summary)
4. Set `last_updated` in the YAML frontmatter to today's date in ISO 8601 format
5. Map the journey stage to the frontmatter `stage` field: "starting-out", "getting-traction", or "scaling"
6. The Clients Summary section should list any existing client subdirectories found in `context/clients/` (using `ls -d context/clients/*/`), reading each client's main file at `context/clients/{dir-name}/{dir-name}.md`, or show "No clients added yet" with a pointer to `/agency-ops:new-client`
