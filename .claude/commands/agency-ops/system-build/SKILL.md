---
name: agency-ops:system-build
description: Guide system architecture template selection and customization for client automations
argument-hint: "<client-name>"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# System Build -- Template Router

I'll guide you through planning the automation architecture for your client's voice agent system. This skill is a template router -- it reads your n8n architecture guides, customizes them for the client, and saves a system architecture document.

## Rules

1. Read `context/agency.md` for agency context (tech stack, automation tool preferences).
2. Read this skill's `learnings.md` for accumulated preferences or patterns.
3. If `$ARGUMENTS` is provided, use it as the client name. Otherwise, use `AskUserQuestion`: "Which client are you building automations for?"
4. Read `context/clients/{client-name}/{client-name}.md` if it exists. If no client file exists, suggest running `/agency-ops:new-client` first but allow continuing without one.
5. Check if a voice-agent-design.md exists for this client (`context/clients/{client-name}/voice-agent-design.md`). If yes, read it for context on which voice agent use case was selected.

## Stage 1: Architecture Assessment

Ask the user about their client's automation needs to recommend the right system architecture. Use `AskUserQuestion` for each question individually.

### Question 1: Voice Agent Status

"Is the voice agent already built, or are you planning the automations alongside the agent build?"
- Already live and working
- Currently being built
- Not started yet (planning phase)

### Question 2: Primary Automation Need

"What automation does your client need most?"
- Pre-call: Something needs to happen BEFORE the agent makes/receives a call (trigger logic, lead routing, data enrichment)
- Post-call: Something needs to happen AFTER a call ends (reporting, CRM updates, notifications, follow-up actions)
- Both pre-call and post-call
- Not sure yet (I'll help you figure it out)

### Question 3: Integration Points

"What systems does the client use that need to connect to the voice agent?"
- CRM (which one?)
- Calendar/booking system
- Payment processor
- Email marketing platform
- Custom database or spreadsheet
- Other (describe)

## Stage 2: Guide Review and Customization

Based on the assessment, read the appropriate guide(s):
- Pre-call automation: `templates/systems/pre-call-automation.md`
- Post-call reporting: `templates/systems/post-call-reporting.md`
- Both (most common for production deployments)

Walk through key decision points with the user via `AskUserQuestion`:
1. "What triggers the pre-call flow?" (form submission, missed call webhook, schedule, manual trigger)
2. "What should happen after each call?" (CRM update, notification, follow-up scheduling, dashboard logging)
3. "Are you using Supabase for dashboard data?" (reference schema extension if yes)
4. "What's your comfort level with n8n?" (adjust guidance depth accordingly)

Customize the guide with client-specific details -- replace {{variables}} with actual integration names, webhook URLs, and data flow specifics.

## Stage 3: Architecture Design

Using the guide as a framework, create a client-specific architecture:
- Customize the mermaid diagram with client-specific systems (their CRM, their calendar tool, their notification preferences)
- Map integration points to specific n8n node types
- Identify which components the client needs vs which are optional
- Apply the n8n vs code decision matrix from the guide to the client's scale and complexity

Present the architecture to the user and ask for adjustments using `AskUserQuestion`:
"Here's the architecture I'd recommend for [client]. Does this match your plan, or should we adjust anything?"

## Stage 4: Output and Save

Generate and save a client-specific system architecture document:

**File:** `context/clients/{client-name}/system-architecture.md`

The architecture doc includes:
- Header with client name, architecture type, voice platform, date
- Architecture overview (mermaid diagram customized for client)
- Component list with specific n8n node types
- Integration details (CRM endpoints, webhook URLs, API references)
- Data flow description
- Estimated build time
- Testing checklist items
- Graduation path notes (when to move from n8n-only to hybrid to code)

Show the user a summary:
- What was created
- File location: `context/clients/{client-name}/system-architecture.md`
- Next steps: "Build this in n8n following the architecture guide, then test with the approach described in the guide."
- Reference: "The full architecture guides are at `templates/systems/pre-call-automation.md` and `templates/systems/post-call-reporting.md`"

## Stage-Gated Adjustments

- **Starting out (0-2 clients):** Keep it simple -- post-call reporting first so the client sees value immediately (call summaries in their CRM). Skip pre-call unless the use case requires it (S2L).
- **Growing (3-10 clients):** Standardize n8n workflows across clients. Build a base workflow template for each architecture type and duplicate/customize per client.
- **Scaling (10+ clients):** Consider shared infrastructure -- one Supabase project with per-client tables, a master n8n instance with client-specific sub-workflows. Reference the graduation path from the architecture guides.

## Learnings Update

After completing the assessment, append a learning entry to `learnings.md`:

```markdown
- **[date]** [tag:system-build] [client/context]: [architecture type, integrations, gotchas]
```

Keep entries concise. Focus on integration-specific gotchas and reusable patterns (e.g., "ServiceTitan webhook format requires custom parsing in Code node").

## Supabase Sync

After saving the architecture doc, if `context/agency.md` has valid `supabase_url` and `supabase_anon_key`:
- Upsert to `agent_configs` table: client_id (lookup by client name), architecture_type, status='planning'
- Use the same curl pattern from `/agency-ops:new-client` with `Prefer: resolution=merge-duplicates`
- If curl fails, note "Dashboard sync skipped" and continue
