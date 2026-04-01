---
name: agency-ops:proposal
description: Generate proposal artifacts, post-discovery follow-up emails, and fill contract templates
argument-hint: "<client-name>"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Proposal Generator

I'll help you create proposals, follow-up emails, and fill contract templates for your clients. I can generate Claude artifact prompts for interactive proposal presentations, draft post-discovery follow-up emails, and fill your SOW, service agreement, and onboarding checklist templates.

## Rules

1. Read `context/agency.md` first for agency name, niche, pricing, services, and communication style.
2. Read this skill's `learnings.md` BEFORE generating any output. Adapt to any patterns or preferences found.
3. If `$ARGUMENTS` is provided, use it as the client name. Otherwise use `AskUserQuestion` to ask for the client name.
4. Read `context/clients/{client-name}/{client-name}.md` for client-specific context (project scope, contacts, monthly value, use case).
5. If client file doesn't exist, offer to create one via `/agency-ops:new-client` or proceed with manual input.
6. This skill is read-only for client and agency files -- it does NOT modify them.
7. Read `templates/proposals/` for template references when filling SOW, service agreement, or onboarding checklist.
8. Read `references/artifact-prompt-template.md` for the artifact prompt format when generating proposals.

## SOP References

Before generating proposals or contracts, read this SOP for scope management context:
- Read `context/sops/scope-management.md` -- reference the scope boundaries (Section 2) and phased delivery approach (Section 3) when generating SOW deliverables and exclusions. Use the scope creep prevention language (Section 4) in service agreement terms.

## Actions

After reading agency and client context, ask the user which action they want:

1. **Generate Proposal Artifact** -- Create a Claude artifact prompt for an interactive proposal presentation
2. **Generate Follow-Up Email** -- Draft a post-discovery follow-up email
3. **Fill SOW Template** -- Fill the scope of work template with client details
4. **Fill Service Agreement** -- Fill the service agreement template
5. **Fill Onboarding Checklist** -- Fill the onboarding checklist for client kickoff

### Generate Proposal Artifact

Create a Claude artifact prompt that, when pasted into Claude's artifact UI, generates an interactive React-based proposal presentation.

**Collect via AskUserQuestion** (if not already in the client file):
- Project description and proposed solution
- Key deliverables (what the client will receive)
- Timeline (weeks or months)
- Pricing tier or custom pricing
- Expected ROI metrics (call volumes, conversion rates, cost savings)

**Process:**
1. Read `references/artifact-prompt-template.md` for the prompt structure.
2. Fill the template with client and agency context:
   - Agency name, niche, and branding from `context/agency.md`
   - Client name, industry, project scope, and use case from client file
   - Collected answers for deliverables, timeline, pricing, and ROI
3. Include voice-AI-specific metrics: call volumes, conversion rates, response times, cost per call, minutes included.
4. Output the complete prompt as a copy-friendly markdown block.
5. Tell the user: "Copy this prompt into Claude and ask it to create an artifact. You'll get an interactive proposal presentation you can share with your client."

### Generate Follow-Up Email

Draft a post-discovery follow-up email that matches your agency's communication style.

**Collect via AskUserQuestion:**
- "How did the discovery call go? What were the key takeaways?"
- "What were the 2-3 main pain points they mentioned?"
- "What next steps did you discuss?"

**Draft the email:**
- Thank them for their time
- Recap 2-3 key pain points discussed during the call
- Briefly describe the proposed solution (voice AI approach tailored to their situation)
- Outline next steps (proposal review, SOW, timeline)
- Include a soft CTA (schedule a follow-up, review the attached proposal)
- Match the tone and style from `context/agency.md` Communication Style section

**Output** as a copy-friendly block with subject line suggestion.

### Fill SOW Template

Fill the scope of work template with client and agency details.

1. Read `templates/proposals/scope-of-work.md`.
2. Collect any missing information via AskUserQuestion (pricing tier, timeline, specific deliverables).
3. Replace all `{{variable}}` placeholders with actual values from agency.md, client file, and collected answers.
4. Output the filled SOW. Tell the user they can save it or adjust as needed.

### Fill Service Agreement

Fill the service agreement template with client and agency details.

1. Read `templates/proposals/service-agreement.md`.
2. Collect any missing information via AskUserQuestion (start date, term length, monthly fee, payment terms).
3. Replace all `{{variable}}` placeholders with actual values.
4. Output the filled agreement.

### Fill Onboarding Checklist

Fill the onboarding checklist with client-specific details for kickoff.

1. Read `templates/proposals/onboarding-checklist.md`.
2. Fill with client-specific details from the client file (CRM type, voice AI platform, contact names).
3. Collect any missing information via AskUserQuestion (phone numbers, business hours, transfer rules).
4. Output the filled checklist. The user can use this to track onboarding progress.

## Stage-Gated Adjustments

Adjust output based on the agency's stage from `context/agency.md`:

- **Starting Out (0-2 clients):** Simpler proposal format. Suggest starting with a one-page project overview instead of a full SOW. Encourage competitive pricing to land first clients. Skip the service agreement for now -- a simple email confirmation may be enough. Focus the proposal on solving one specific pain point.

- **Getting Traction (3-10 clients):** Full proposal flow with all templates. Suggest including case studies or results from existing clients in the proposal artifact. Reference specific metrics from past projects (e.g., "We helped Sunrise Dental increase form-to-appointment conversion from 15% to 66%").

- **Scaling (10+ clients):** Add "Upsell Opportunities" section to proposals suggesting additional use cases (after-hours coverage, database reactivation, multi-location rollout). Suggest tiered pricing for ongoing value capture. Include a "Partnership Roadmap" showing how the engagement can grow over 6-12 months.

## Learnings Update

After generating any output, check if the user provides feedback or adjustments. If they do, append a learning to `learnings.md`:

```
### [Date] - [Category]
**Context:** [What was generated]
**Learning:** [What the user preferred or adjusted]
**Tags:** #proposal #[action-type]
```

Categories: Preferences (formatting, tone, structure), Situational (client-type-specific patterns), Pruned (outdated entries removed when hitting 30 max).

## Empty State

If no client file exists for the requested client:

> I can still generate a generic proposal, but it works much better with a client file for context. Run `/agency-ops:new-client` to create one first, then come back here.
>
> Want me to proceed with manual input instead?

If `context/agency.md` has not been personalized (still contains `{{variable}}` placeholders):

> Your agency context hasn't been set up yet. Run `/agency-ops:onboarding` first so I can personalize your proposals with your agency name, pricing, and communication style.
