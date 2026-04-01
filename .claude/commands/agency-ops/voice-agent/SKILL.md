---
name: agency-ops:voice-agent
description: Guide voice agent template selection, customization, and Retell prompt creation for a client
argument-hint: "<client-name>"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Voice Agent Design -- Template Router

I'll guide you through selecting, customizing, and deploying a voice agent for your client. This skill is a template router -- it reads your templates, customizes them for the client, creates a Retell prompt, and saves everything to the client's file.

## Rules

1. Read `context/agency.md` first for agency context (niche, tech stack, voice platform).
2. Read this skill's `learnings.md` for accumulated preferences.
3. If `$ARGUMENTS` is provided, use it as the client name. Otherwise, use `AskUserQuestion`: "Which client are you building a voice agent for?"
4. Read `context/clients/{client-name}/{client-name}.md` if it exists. If no client file exists, suggest running `/agency-ops:new-client` first but allow continuing without one.
5. This skill has natural stopping points between stages. The user can stop after any stage and pick up later.

## Stage 1: Use Case Assessment (5 minutes)

Ask the user about their client's situation to recommend the right voice agent type. Use `AskUserQuestion` for each question individually.

### Question 1: Primary Pain Point

"What's the main problem your client is trying to solve?"
- Missed calls or overwhelmed front desk
- Slow follow-up on web form leads
- Dormant customer list they want to re-engage
- Something else (describe)

### Question 2: Call Volume and Context

Based on their answer, ask the relevant follow-up:

**If missed calls / front desk:**
- "How many calls do they get per day?"
- "What happens after hours -- voicemail, answering service, or nothing?"
- "Do they have multiple locations or just one?"

**If slow lead response:**
- "How quickly do they currently follow up on web form submissions?"
- "How many form submissions do they get per week?"
- "What's their current process -- someone checks email and calls back manually?"

**If dormant customers:**
- "How many inactive customers do they have in their database?"
- "When was the last time they did any kind of re-engagement campaign?"
- "What would they want the outreach to offer -- appointment booking, special promotion, just a check-in?"

## Use Case Types

Based on the assessment, recommend one of these three voice agent types:

### Inbound Receptionist

**Best for:** Businesses with high call volume, after-hours gaps, or receptionist bottlenecks.

**What it does:** Answers incoming calls, greets the caller, asks qualifying questions, books appointments or transfers to staff based on rules.

**Key components:**
- Inbound call handling with greeting and qualification flow
- Calendar/booking system integration
- CRM logging of every call outcome
- Transfer rules (when to route to a human)
- After-hours vs business hours behavior
- Voicemail handling for calls the agent cannot resolve

**Typical setup timeline:** 1-2 weeks

**Success metrics to track:**
- Missed call reduction percentage
- After-hours calls answered
- Appointments booked by agent vs front desk
- Average call duration
- Transfer rate (lower is better once trained)

### Speed-to-Lead (S2L)

**Best for:** Businesses with web forms, landing pages, or lead magnets where response time directly impacts conversion.

**What it does:** When a lead submits a form, the AI calls them within 60 seconds, qualifies them, and books an appointment or next step.

**Key components:**
- Form submission webhook trigger (website form, Google Ads, Facebook Lead Ads)
- Outbound call initiation via Retell API
- Qualifying question flow tailored to the business
- CRM integration to log lead status and call outcome
- SMS fallback if the lead does not answer the call
- Retry logic (call back once after 30 minutes if no answer)

**Typical setup timeline:** 1-2 weeks

**Success metrics to track:**
- Form-to-appointment conversion rate (before vs after)
- Average lead response time (target: under 60 seconds)
- Contact rate (percentage of leads who answer)
- Qualified lead rate

### Database Reactivation (DBR)

**Best for:** Businesses with 500+ inactive customers who have not been contacted in 6+ months.

**What it does:** Makes outbound calls to dormant customers with a specific offer (appointment, promotion, check-in), qualifies interest, and books next steps.

**Key components:**
- Customer list import and segmentation
- Outbound calling campaign with batch scheduling
- Personalized greeting using customer name and history
- Offer presentation and objection handling
- Appointment booking or warm transfer for interested customers
- Do-not-call list management and compliance
- Campaign progress tracking and reporting

**Typical setup timeline:** 2-3 weeks (includes list preparation and compliance review)

**Success metrics to track:**
- Contact rate (calls answered / calls made)
- Re-engagement rate (interested / contacted)
- Appointments booked from campaign
- Revenue generated from reactivated customers
- ROI (revenue vs campaign cost)

## Recommendation

After the assessment, recommend one of the three use cases with reasoning based on the client's specific answers. Provide:
1. **Recommended use case type** with reasoning
2. **Key components needed** for their situation
3. **Integrations required** (CRM, calendar, phone system, form platform)
4. **Estimated setup timeline**
5. **Success metrics** they should propose to the client

Ask: "Does this recommendation match what you had in mind, or should we explore a different use case?"

## Stage 2: Template Review and Customization (5 minutes)

Based on the recommended use case, read the corresponding template:
- Inbound Receptionist: `templates/voice-agents/inbound-receptionist.md`
- Speed-to-Lead: `templates/voice-agents/speed-to-lead.md`
- Database Reactivation: `templates/voice-agents/database-reactivation.md`

Walk through the template sections with the user using `AskUserQuestion`:
1. "Let me show you the call flow for [use case]. Does this match what you need, or should we adjust?" (Show the mermaid diagram from the template)
2. "What CRM does your client use?" (if not already in the client file)
3. "Do they have a booking/calendar system?" (if applicable to the use case)
4. "Any specific integrations or requirements I should know about?"

Customize the template with client-specific answers -- replace {{variables}} with actual values.

## Stage 3: Knowledge Base Gathering (10 minutes)

Read `templates/voice-agents/_shared/kb-gathering-template.md`.

Walk through the KB gathering template with the user using `AskUserQuestion`:
- Fill in business basics (name, hours, location)
- Fill in top services and pricing
- Fill in common caller questions (FAQ)
- Fill in policies and transfer rules
- Fill in greeting preferences

Explain: "This information goes directly into the Retell system prompt -- there's no separate knowledge base file. The more detail here, the better the agent handles real calls."

The user can do this live or come back with answers later. If they want to pause, save progress to the client's design doc and note where they left off.

## Stage 4: Retell Prompt Creation (15-20 minutes)

This is the deep work. Read the appropriate prompt engineering reference:
- If client uses Retell (default/recommended): Read `references/prompt-engineering-retell.md`
- If client uses ElevenLabs: Read `references/prompt-engineering-elevenlabs.md`

**Retell prompt creation flow:**
1. Read the corresponding system prompt template: `templates/voice-agents/retell-prompts/inbound-system-prompt.md` (for inbound) or `templates/voice-agents/retell-prompts/outbound-system-prompt.md` (for S2L/DBR)
2. Replace all {{VARIABLES}} with the client's specific information from Stages 2-3
3. Follow the GPT 4.1 prompt structure: Role and Objective, Personality, Context, Instructions, Stages, Example Interactions
4. Include all voice agent best practices from the reference: one question at a time, symbol formatting, spelling rules, function integration, jailbreak protection
5. Keep under 2000 tokens excluding knowledge base content
6. Show the completed prompt to the user for review
7. Ask: "Want to adjust anything -- the tone, the greeting, the transfer rules, or the FAQ answers?"

**Retell config guidance:**
Point the user to `templates/voice-agents/retell-configs/` for the appropriate config template (inbound or outbound). Explain that they need to:
1. Replace {{VARIABLES}} in the JSON config
2. Import to Retell via their dashboard or API
3. Set the system prompt to the one we just created

Also show the E2E test configs at `templates/voice-agents/retell-configs/e2e-test-receiver.json` and `templates/voice-agents/retell-configs/e2e-test-caller.json` for testing.

## Stage 5: Output and Save

Generate and save a client-specific voice agent design document:

**File:** `context/clients/{client-name}/voice-agent-design.md`

The design doc includes:
- Header with client name, use case, voice platform, date
- Call flow (the customized mermaid diagram)
- Integrations list (specific to this client)
- CRM touchpoints (specific to this client's CRM)
- The completed Retell system prompt
- Testing checklist with any client-specific items
- Go-live timeline
- Success metrics with baseline targets for this client

Show the user a summary:
- What was created
- File location: `context/clients/{client-name}/voice-agent-design.md`
- Next steps: "Review the design doc, share the call flow with your client, run test calls once configured in Retell"
- Reference: "Use the testing checklist at `templates/voice-agents/_shared/testing-checklist.md` and go-live runbook at `templates/voice-agents/_shared/go-live-runbook.md`"
- Suggested next step: "Run `/agency-ops:system-build {client-name}` to plan the n8n automations around this voice agent."

## Stage-Gated Adjustments

- **Starting out (0-2 clients):** Recommend Inbound Receptionist as easiest starting point -- it has the clearest value proposition and simplest integration requirements. Spend more time on KB gathering (user is learning the process). Simpler prompt with fewer stages.
- **Growing (3-10 clients):** Can offer all three types. Look for upsell opportunities -- start with Inbound Receptionist, then add S2L as Phase 2. Faster KB gathering (user knows what to ask).
- **Scaling (10+ clients):** Suggest standardizing on 1-2 use cases per niche for operational efficiency. Reuse customized templates across similar clients. Focus on optimization, not creation.

## Learnings Update

After completing any stage, append a learning entry to `learnings.md`:

```markdown
- **[date]** [tag:voice-agent] [client/niche context]: [what was recommended, customizations made, any user adjustments]
```

Keep entries concise. Focus on patterns that will help future assessments (e.g., "dental offices almost always need Inbound Receptionist first, then S2L as Phase 2").

## Supabase Sync

After saving the design doc, if `context/agency.md` has valid `supabase_url` and `supabase_anon_key`:
- Upsert to `agent_configs` table: client_id (lookup by client name), use_case, voice_platform, status='building'
- Use the same curl pattern from `/agency-ops:new-client` with `Prefer: resolution=merge-duplicates`
- If curl fails, note "Dashboard sync skipped" and continue
