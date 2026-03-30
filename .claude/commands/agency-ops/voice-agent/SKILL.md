---
name: agency-ops:voice-agent
description: Guide voice agent template selection and customization for a client
argument-hint: "<client-name>"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Voice Agent Guide

I'll help you choose and plan the right voice agent for your client. We'll assess their needs, recommend a use case type, and outline the key components so you can scope the project confidently.

## Rules

1. Read `context/agency.md` to understand the user's agency context (niche, tech stack, voice platform).
2. Read this skill's `learnings.md` for any accumulated preferences or patterns.
3. If `$ARGUMENTS` is provided, use it as the client name. Otherwise, use `AskUserQuestion` to ask: "Which client are you planning a voice agent for?"
4. If a client file exists at `context/clients/{client-name}.md`, read it for project context, industry, and existing scope.
5. If no client file exists, proceed with the assessment based on the user's answers.

## Use Case Assessment

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
- Outbound call initiation via Retell/Vapi/ElevenLabs API
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

## Recommendation Output

After the assessment, provide the user with:

1. **Recommended use case type** with reasoning based on their specific answers.
2. **Key components needed** for their client's situation.
3. **Integrations required** (CRM, calendar, phone system, form platform).
4. **Estimated setup timeline** based on complexity.
5. **Success metrics** they should propose to the client.
6. **Discovery questions** to discuss with the client before scoping.
7. **Suggested next step:** "Run `/agency-ops:proposal` to generate a proposal for this project."

## Phase 4 Note

Detailed system design document templates are coming in Phase 4. These will include call flow diagrams, integration specs, platform-specific configuration guides, testing checklists, and go-live runbooks for each use case type.

For now, use this guidance to scope the project, discuss the approach with your client, and create a proposal with `/agency-ops:proposal`.

## Stage-Gated Adjustments

- **Starting out (0-2 clients):** Focus on a single use case type per client. Recommend Inbound Receptionist as the easiest starting point -- it has the clearest value proposition and simplest integration requirements.
- **Growing (3-10 clients):** Can offer all three types. Look for upsell opportunities: start with S2L, then add Inbound Receptionist as Phase 2.
- **Scaling (10+ clients):** Consider standardizing on 1-2 use cases per niche for operational efficiency. Build reusable call flows that you customize per client rather than building from scratch each time.

## Learnings Update

After completing the assessment, append a learning entry to this skill's `learnings.md`:

```markdown
- **[date]** [tag:voice-agent] [client/niche context]: [what was recommended and why, any user adjustments to the recommendation]
```

Keep entries concise. Focus on patterns that will help future assessments (e.g., "dental offices almost always need Inbound Receptionist first, then S2L as Phase 2").
