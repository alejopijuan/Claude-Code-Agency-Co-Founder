---
name: agency-ops:system-build
description: Guide system architecture template selection for client automations
argument-hint: "<client-name>"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# System Build Guide

I'll help you plan the automation system architecture for your client. We'll figure out what automations are needed around the voice agent and recommend the right approach.

## Rules

1. Read `context/agency.md` to understand the user's agency context (tech stack, automation tool preferences).
2. Read this skill's `learnings.md` for any accumulated preferences or patterns.
3. If `$ARGUMENTS` is provided, use it as the client name. Otherwise, use `AskUserQuestion` to ask: "Which client are you building automations for?"
4. If a client file exists at `context/clients/{client-name}.md`, read it for project context, integrations, and active projects.
5. If no client file exists, proceed with the assessment based on the user's answers.

## Architecture Assessment

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

## Architecture Types

Based on the assessment, recommend one or both of these system architectures:

### Pre-Call Automation

**Best for:** Speed-to-lead setups, lead routing, data enrichment before the agent calls.

**What it does:** Receives a trigger (form submission, missed call webhook, scheduled event), processes the data, and initiates the voice agent call with the right context.

**Architecture overview:**
1. **Trigger node** -- Webhook receives form data, missed call notification, or scheduled event.
2. **Data enrichment** -- Look up the lead in CRM. Check for existing record. Pull any relevant history.
3. **Routing logic** -- Determine which call flow to use (based on lead source, time of day, location, etc.).
4. **Agent trigger** -- Call Retell/Vapi/ElevenLabs API to initiate the outbound call with enriched context.
5. **Error handling** -- If the API call fails, retry once. If retry fails, log the error and notify you via Slack/email.
6. **Logging** -- Record the trigger event and call initiation in a tracking system (Supabase, Google Sheets, or CRM).

**Required n8n nodes:**
- Webhook (trigger)
- HTTP Request (CRM lookup, voice AI API call)
- IF/Switch (routing logic)
- Error Trigger (error handling)
- Slack/Email (notifications)

**Estimated build time:** 2-4 hours for a basic flow, 4-8 hours with complex routing.

**Testing approach:**
- Send test webhook payloads with sample lead data.
- Verify CRM lookup returns correct data.
- Confirm agent receives the right context.
- Test error paths (CRM down, API timeout, malformed data).

### Post-Call Reporting

**Best for:** Clients who want visibility into call outcomes, automated CRM updates, and follow-up actions after calls.

**What it does:** Receives call completion data from the voice AI platform, extracts structured information, updates the CRM, and triggers follow-up actions.

**Architecture overview:**
1. **Call webhook** -- Receive call completion event from Retell/Vapi/ElevenLabs with recording URL, transcript, duration, and outcome.
2. **Data extraction** -- Parse the transcript or structured data to extract: caller intent, appointment details, follow-up needed, sentiment.
3. **CRM update** -- Create or update the contact record with call outcome, notes, and next steps.
4. **Notification** -- Send a summary to the client (Slack message, email) with key call details.
5. **Follow-up trigger** -- If the call outcome requires follow-up (send info, schedule callback, send confirmation), trigger the appropriate action.
6. **Dashboard insert** -- Log structured call data to Supabase or Google Sheets for reporting and analytics.

**Required n8n nodes:**
- Webhook (call completion trigger)
- HTTP Request (CRM update, Supabase insert)
- Code (data extraction from transcript)
- Slack/Email (notifications)
- IF/Switch (follow-up routing based on call outcome)

**Estimated build time:** 3-5 hours for basic reporting, 6-10 hours with advanced extraction and multi-system updates.

**Testing approach:**
- Use sample call completion payloads from the voice AI platform's documentation.
- Verify data extraction produces correct structured output.
- Confirm CRM records are created/updated accurately.
- Test notification delivery and formatting.
- Validate dashboard data appears correctly.

## Recommendation Output

After the assessment, provide the user with:

1. **Recommended architecture type(s)** with reasoning.
2. **Architecture diagram** in text format showing the flow of data between systems.
3. **Required integrations** and which n8n nodes to use.
4. **Estimated build time** based on complexity.
5. **Testing checklist** for validating the system works end-to-end.
6. **Potential gotchas** specific to their setup (e.g., "Dentrix has no open API, so you'll need a Zapier bridge," or "GoHighLevel webhooks require a specific format").

## Phase 4 Note

Detailed n8n workflow architecture guides with step-by-step build instructions, node-by-node configuration, and version-pinned references are coming in Phase 4. These will include importable workflow JSON templates and troubleshooting guides.

For now, use this guidance to plan the architecture, estimate the build effort, and discuss the approach with your client. Reference `context/sops/client-onboarding.md` for the tool setup steps during onboarding.

## Stage-Gated Adjustments

- **Starting out (0-2 clients):** Keep it simple. Build post-call reporting first so your client sees value immediately (call summaries in their CRM). Add pre-call automation only if the use case requires it (S2L).
- **Growing (3-10 clients):** Standardize your n8n workflows. Create a base workflow template for each architecture type and duplicate/customize per client rather than building from scratch.
- **Scaling (10+ clients):** Consider a shared infrastructure approach: one Supabase project with per-client tables, a master n8n instance with client-specific sub-workflows, and a central error monitoring dashboard.

## Learnings Update

After completing the assessment, append a learning entry to this skill's `learnings.md`:

```markdown
- **[date]** [tag:system-build] [client/context]: [what was recommended, integration challenges noted, any user adjustments]
```

Keep entries concise. Focus on integration-specific gotchas and reusable patterns (e.g., "ServiceTitan webhook format requires custom parsing in Code node").
