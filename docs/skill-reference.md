# Skill Reference

> Your agency, your way. Each skill is designed to be customized. This guide shows you the design behind each skill and where to make it yours.

This is a design reference -- it explains WHY each skill works the way it does and WHERE you can customize it. For usage instructions, just run the skill and follow the conversation.

---

## How Skills Work

Every skill in Agency Ops Hub follows a consistent architecture:

- **SKILL.md** defines the skill's behavior -- its rules, output format, stage-gated adjustments, and integrations. This is the "brain" of the skill.
- **learnings.md** accumulates knowledge from your usage. Each time you give feedback or Claude notices a pattern, it gets recorded here. Entries are organized into three categories: **Preferences** (lasting choices like "I prefer shorter briefings"), **Situational** (one-time context like "Sunrise Dental prefers email over Slack"), and **Pruned** (outdated entries that were removed). There is a 30-entry cap -- when full, older Situational entries are pruned first.
- **references/** holds templates, examples, and supplementary files the skill draws from (message templates, artifact prompts, SQL schemas).

**Single-file vs directory-based:** Most skills are directories containing `SKILL.md`, `learnings.md`, and `references/`. The one exception is `/agency-ops:onboarding`, which is a single file (`onboarding.md`) -- it runs infrequently and does not need accumulated learnings.

**Self-learning:** The more you use a skill, the better it gets. Claude reads `learnings.md` before every invocation and adapts its output to your preferences and patterns.

**Act / Ask / Absorb:** Skills Act autonomously for file reads and writes, Ask for decisions that need your input (which client, what happened in the meeting), and Absorb context silently (noting patterns for future reference in learnings.md).

**Stage-gated output:** Every skill reads the `stage` field from `context/agency.md` (starting-out, getting-traction, or scaling) and adjusts its depth, tone, and recommendations accordingly. A solo operator with zero clients sees different output than someone managing ten.

---

## Skill Categories

| Category | Skills | Purpose |
|----------|--------|---------|
| **Setup** | onboarding, new-client, setup-dashboard | Configure your agency, add clients, connect your dashboard |
| **Client Operations** | client-briefing, meeting-prep, follow-up, weekly-review | Manage active client relationships day-to-day |
| **Sales & Outreach** | outreach, pipeline, proposal | Find leads, track deals, generate proposals |
| **Delivery** | voice-agent, system-build, lead-gen | Plan and scope voice AI projects *(Coming in Phase 4)* |

---

## /agency-ops:onboarding

**Stage-gated agency setup wizard -- run this first to personalize your toolkit.**

### Design Rationale

- **Single-file skill** (`onboarding.md`, not a directory) because it runs once or rarely. No learnings accumulation needed.
- **First useful output within 3 minutes.** After 2-3 questions, Claude generates `context/agency.md` immediately with sensible defaults for everything else. You can stop at any point and still have a working setup.
- **Progressive disclosure via stages.** The journey check (starting-out, getting-traction, scaling) determines which follow-up questions to ask and how deep to go. Starting-out users skip pricing details; scaling users get asked about CRM and team structure.
- **Defaults for everything.** A 13-field defaults table ensures `agency.md` is always complete, even if you answer only one question. No field is ever left blank.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Questions asked | `## Stage 2: Core Identity` and `## Stage 3: Deeper Context` sections in `onboarding.md` | Add, remove, or reorder questions. Each is a numbered item with a description. |
| Default values | `## Defaults for Skipped Questions` table in `onboarding.md` | Change any default value in the table (agency_name, core_offering, niche, pricing, etc.) |
| Stage thresholds | `## Stage 1: Journey Check` in `onboarding.md` | Modify the three stage descriptions or add a fourth stage |
| Output structure | `## agency.md Generation Instructions` in `onboarding.md` | Adjust section order or add new sections to the generated agency.md |

### What NOT to Change

- **YAML frontmatter field names** in the generated `agency.md` (`agency_name`, `stage`, `niche`, `supabase_url`, `supabase_anon_key`). Every other skill reads these exact field names.
- **Stage values** (`starting-out`, `getting-traction`, `scaling`). All skills use these for stage-gated adjustments.

Try running `/agency-ops:onboarding --reset` to update your profile with your changes.

---

## /agency-ops:new-client

**Create a new client context file through interactive conversation.**

### Design Rationale

- **4 required + 5 optional questions.** Gets a useful client file fast (name + industry + project + use case), then offers deeper customization.
- **Generates immediately after required questions.** You get a working client file within a minute; optional questions refine it afterward.
- **Filename convention matters.** Lowercase hyphenated (`sunrise-dental.md`) -- every skill that reads client files uses this pattern to locate them.
- **Dual-write to Supabase.** After creating the markdown file, syncs to Supabase if credentials are configured. Markdown is always the source of truth.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Required questions | `## Questions > ### Required` section in `SKILL.md` | Add or modify numbered questions. Keep it to 4-5 max for speed. |
| Optional questions | `## Questions > ### Optional` section in `SKILL.md` | Add questions for fields you always want to capture |
| Default values | `## File Generation` section, step 3 in `SKILL.md` | Change defaults for meeting_cadence, staleness_threshold_days, etc. |
| Initial commitment | `## File Generation` section, step 4 in `SKILL.md` | Change the default first commitment entry |
| Client template | `context/clients/_template.md` | Add new sections or fields to the template all clients use |

### What NOT to Change

- **YAML frontmatter field names** in client files (`name`, `industry`, `status`, `monthly_value`, `start_date`, `meeting_cadence`, `last_updated`, `staleness_threshold_days`, `open_commitments_count`, `next_meeting_date`). The dashboard reads these exact fields.
- **Filename convention** (lowercase-hyphenated). All skills use this to find client files.
- **Commitments Log table format** (Date, Commitment, Owner, Status, Due columns). Follow-up skill appends to this table.

Try running `/agency-ops:new-client` to see your changes in action.

---

## /agency-ops:setup-dashboard

**Connect your agency dashboard to Supabase for live data visualization.**

### Design Rationale

- **Playwright-first with manual fallback.** Tries browser automation first; falls back gracefully to step-by-step instructions if Playwright MCP is not available. Partial automation is fine.
- **Dual credential storage.** Supabase URL and key are stored in both `context/agency.md` (for skills to read during dual-write) and browser `localStorage` (for the dashboard to read at runtime).
- **Bulk initial sync.** After setup, reads all existing markdown files in outreach/, pipeline/, and clients/ and syncs them to Supabase so the dashboard is populated immediately.
- **Error-tolerant.** Every step has a recovery path. If the SQL fails, troubleshoot. If credentials are wrong, re-enter. If sync fails, it will catch up next time a skill runs.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Supabase schema | `references/supabase-schema.sql` in the skill directory | Add columns or tables for custom data you want to track |
| Sync fields | `## Bulk Initial Sync` section in `SKILL.md` | Add fields to the JSON arrays for leads, deals, or clients |
| Setup flow | `## Playwright Path` and `## Manual Path` sections in `SKILL.md` | Reorder steps or add custom instructions |
| Verification steps | `## Verification` section in `SKILL.md` | Add troubleshooting steps for common issues |

### What NOT to Change

- **localStorage key names** (`supabase_url`, `supabase_anon_key`). The dashboard JavaScript reads these exact keys.
- **Supabase table names** (`leads`, `deals`, `clients`). Skills use these in curl commands for dual-write.
- **agency.md credential field names** (`supabase_url`, `supabase_anon_key`). Every skill checks these before attempting Supabase sync.

Try running `/agency-ops:setup-dashboard` to connect your dashboard.

---

## /agency-ops:client-briefing

**Generate a comprehensive briefing for a specific client before meetings or context-switching.**

### Design Rationale

- **Read-only.** This skill never modifies client files. It reads and synthesizes, giving you a compact snapshot without side effects.
- **Compact output, not walls of text.** Status Snapshot, Open Commitments, Key Contacts, Talking Points, Recent Activity -- each section is designed to be scannable in under 30 seconds.
- **Actionable talking points.** Generated from real data: overdue commitments, stale items, upcoming deadlines, recent meeting outcomes. Never generic filler.
- **Staleness detection.** Compares `last_updated` against `staleness_threshold_days` and surfaces a warning when a client file is going stale.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Output sections | `## Output Format` section in `SKILL.md` | Add, remove, or reorder the subsections (Status Snapshot, Project Overview, etc.) |
| Talking point sources | `## Output Format > ### Talking Points` in `SKILL.md` | Add new data sources for talking point generation |
| Staleness threshold | `staleness_threshold_days` in each client file's YAML frontmatter | Adjust per-client (default 14 days) |
| Stage-gated depth | `## Stage-Gated Adjustments` section in `SKILL.md` | Modify what each stage sees (starting-out gets lighter output, scaling gets trend indicators) |

### What NOT to Change

- **Read-only behavior.** This skill should never write to client files. That is follow-up's job.
- **YAML frontmatter field names** it reads from client files. Changing those breaks the briefing.

Try running `/agency-ops:client-briefing <client-name>` to see your changes.

---

## /agency-ops:meeting-prep

**Generate a structured meeting agenda with open tasks, follow-ups, and questions to ask.**

### Design Rationale

- **Numbered agenda with time allocations.** Designed to be used directly in a meeting -- scannable, structured, with suggested time blocks for each section.
- **Pre-Meeting Checklist with checkboxes.** Actionable preparation steps you can tick off before the call.
- **Auto-generated questions.** Claude analyzes gaps in the client file, stale items, upcoming deadlines, and upsell opportunities to generate 3-5 concrete questions to ask.
- **Two optional inputs.** You can specify custom topics and meeting type, or skip both and get a complete agenda from client file data alone.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Agenda items | `## Output Format > ### Agenda` section in `SKILL.md` | Add or remove numbered agenda items, adjust time allocations |
| Question generation sources | Agenda item 6 in `## Output Format > ### Agenda` in `SKILL.md` | Add new data sources for question generation |
| Pre-Meeting Checklist | `## Output Format > ### Pre-Meeting Checklist` in `SKILL.md` | Add preparation steps relevant to your workflow |
| Meeting types | `## Input Gathering` question 2 in `SKILL.md` | Add meeting types (e.g., quarterly review, onboarding kickoff) |

### What NOT to Change

- **Client file field names** that the agenda reads (Active Projects, Commitments Log, Meeting Notes, Key Contacts sections).
- **Lowercase-hyphenated client name convention** for file lookup.

Try running `/agency-ops:meeting-prep <client-name>` before your next meeting.

---

## /agency-ops:follow-up

**Process meeting notes into action items, draft follow-up email, and update client file.**

### Design Rationale

- **The ONLY skill that writes to client files.** This is intentional -- it prevents accidental overwrites. All client file modifications flow through follow-up.
- **Append-only writes.** New rows are added to the Commitments Log and Meeting Notes sections. Existing rows are never edited or deleted. Status updates are recorded as new rows with an `[Update]` prefix.
- **Email draft matches your communication style.** Reads the Communication Style section from `agency.md` (tone, example phrases) and generates an email you can copy-paste directly.
- **Shows changes before writing.** Displays exactly what will be appended to the client file and asks for confirmation before writing.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Email format | `## Output Format > ### Draft Follow-Up Email` section in `SKILL.md` | Modify the email template structure, add sections, change the sign-off |
| Due date defaults | `## Processing` step 3 in `SKILL.md` | Change default due dates (currently 7 days) or urgency mappings ("ASAP" = 2 days) |
| Action item extraction | `## Processing` step 1 in `SKILL.md` | Add trigger phrases for action item detection |
| Meeting Notes format | `## Client File Update > ### Meeting Notes` in `SKILL.md` | Change the format of meeting note entries |
| Communication style | `context/agency.md` Communication Style section | Update your tone and example phrases -- follow-up will match them |

### What NOT to Change

- **Append-only behavior.** Never change this to edit existing rows -- it is a deliberate audit trail design.
- **Commitments Log table columns** (Date, Commitment, Owner, Status, Due). Weekly-review and client-briefing depend on this format.
- **`last_updated` frontmatter field.** Follow-up sets this on every write; other skills use it for staleness detection.

Try running `/agency-ops:follow-up <client-name>` after your next meeting.

---

## /agency-ops:weekly-review

**Cross-client summary with priorities, stale file flags, and forgotten commitment alerts.**

### Design Rationale

- **Explicitly READ-ONLY on client files.** The Write tool is only used for `learnings.md`. This skill is a reporting tool, not an editor.
- **Cross-client analysis.** Reads EVERY client file and synthesizes a single operational summary. No client is skipped.
- **Three-tier health system.** Good (within staleness threshold, no overdue items), Attention (approaching threshold or items due soon), At Risk (stale or overdue). Simple, visual, actionable.
- **Priorities ranked by urgency.** Overdue items first, then items due this week, then stale clients, then upcoming deadlines. Always actionable with specific skill commands to run.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Health thresholds | `## Output Format > ### Client Health Summary` in `SKILL.md` | Adjust what qualifies as Attention vs At Risk (currently 3 days for Attention) |
| Priority ranking | `## Output Format > ### Priorities` in `SKILL.md` | Change the priority order or add new priority sources |
| Output sections | `## Output Format` section in `SKILL.md` | Add, remove, or reorder sections (Week Overview, What Happened, What's Due, At Risk, etc.) |
| Forgotten commitment threshold | `## Output Format > ### At Risk` in `SKILL.md` | Change the 7-day threshold for "forgotten" commitments |

### What NOT to Change

- **Read-only behavior on client files.** This is by design -- weekly-review observes, follow-up acts.
- **Client file field names** it reads (`last_updated`, `staleness_threshold_days`, Commitments Log format, Meeting Notes section).

Try running `/agency-ops:weekly-review` on Monday morning.

---

## /agency-ops:outreach

**Track and manage outreach across channels with message templates and follow-up reminders.**

### Design Rationale

- **Per-lead files in `context/outreach/`.** Each lead gets their own markdown file with YAML frontmatter for structured data and a freeform interaction log for conversation history.
- **3-5-7-14 day follow-up cadence.** Automatically calculates the next follow-up date based on how many interactions have occurred (1st: +3 days, 2nd: +5, 3rd: +7, 4th+: +14).
- **Dual-write to Supabase.** After creating or updating a lead file, syncs to Supabase if configured. Dashboard shows your outreach funnel in real time.
- **Four actions from one skill.** `add`, `status`, `follow-ups`, and `templates` -- covering the full outreach lifecycle without switching between commands.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Follow-up cadence | `## Log Interaction Flow` step 5 in `SKILL.md` | Change the 3-5-7-14 day intervals to match your preferred rhythm |
| Stage progression | `## Log Interaction Flow` step 6 in `SKILL.md` | Add custom stages or change when stages advance |
| Message templates | `references/message-templates.md` in the skill directory | Add templates, modify wording, add channels |
| Status indicators | `## Status Overview` step 3 in `SKILL.md` | Change what Due/OK/Stale mean (currently: 14 days for Stale) |
| Lead file template | `context/outreach/_template.md` | Add custom fields to your lead tracking |
| Channels | `## Add Lead Flow` question 2 in `SKILL.md` | Add channels beyond LinkedIn, Instagram, WhatsApp, email, phone |

### What NOT to Change

- **YAML frontmatter field names** in lead files (`name`, `company`, `channel`, `stage`, `source`, `last_contact`, `next_follow_up`). The dashboard reads these for the outreach funnel chart.
- **Stage names** (`new-lead`, `messaged`, `replied`, `call-booked`, `discovery`, `proposal`, `closed`). Pipeline and dashboard both depend on these exact values.
- **Filename convention** (lowercase-hyphenated from lead name).

Try running `/agency-ops:outreach status` to see your outreach dashboard.

---

## /agency-ops:pipeline

**View and manage your deal pipeline with stage tracking and conversion metrics.**

### Design Rationale

- **Same 7 stages as outreach.** `new-lead -> messaged -> replied -> call-booked -> discovery -> proposal -> closed`. Consistent terminology across the entire system.
- **Stage Transitions table as audit trail.** Every stage change is logged with date, from, to, and notes. This enables conversion metrics computed on the fly -- no stored aggregates.
- **Outreach integration.** Deals can link to outreach lead files via the `outreach_file` field. When a deal moves stages, the linked lead file's stage is updated too.
- **Metrics computed on the fly.** Messages-to-replies ratio, calls-to-close ratio, average time per stage -- all calculated from the Stage Transitions table data, never cached.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Pipeline stages | `## Pipeline Stages` table in `SKILL.md` | Add stages (e.g., "negotiation") or modify descriptions. Update STAGES array in dashboard too. |
| Metrics computed | `## Metrics View` step 3 in `SKILL.md` | Add custom metrics (e.g., average deal value by niche, win rate by channel) |
| Status display | `## Status Overview` step 3 in `SKILL.md` | Change the funnel display format |
| Deal file template | `context/pipeline/_template.md` | Add custom fields to deal tracking |
| Stage skip warning | `## Move Deal Flow` step 5 in `SKILL.md` | Change whether stage skipping shows a warning or is silent |

### What NOT to Change

- **Stage names** (`new-lead`, `messaged`, `replied`, `call-booked`, `discovery`, `proposal`, `closed`). Dashboard, outreach, and pipeline all share these.
- **YAML frontmatter field names** in deal files (`name`, `contact`, `outreach_file`, `stage`, `niche`, `value`, `next_action`, `created`, `last_updated`). Dashboard reads these for the pipeline table.
- **Stage Transitions table format** (Date, From, To, Notes columns). Metrics computation depends on this.

Try running `/agency-ops:pipeline status` to see your deal funnel.

---

## /agency-ops:proposal

**Generate proposal artifacts, post-discovery follow-up emails, and fill contract templates.**

### Design Rationale

- **Five actions from one skill.** Proposal artifact, follow-up email, SOW, service agreement, and onboarding checklist -- covering the full proposal-to-close workflow.
- **Claude artifact prompt generation.** Creates a prompt that, when pasted into Claude's artifact UI, produces an interactive React-based proposal presentation. Your clients see a polished deliverable.
- **Template-driven contract filling.** Reads templates from `templates/proposals/` and replaces all `{{variable}}` placeholders with real values from agency.md and client files.
- **Read-only on client/agency files.** Proposal reads context but never modifies source files -- output is presented for you to use, save, or share.

### Customization Hooks

| What | Where | How |
|------|-------|-----|
| Artifact prompt format | `references/artifact-prompt-template.md` in the skill directory | Modify the React artifact template, change sections, add branding |
| Email template | `## Actions > ### Generate Follow-Up Email` in `SKILL.md` | Change the email structure, tone, or CTA style |
| SOW template | `templates/proposals/scope-of-work.md` | Add sections, change the 3-phase delivery structure, modify terms |
| Service agreement | `templates/proposals/service-agreement.md` | Change terms, pricing structure, overage policies |
| Onboarding checklist | `templates/proposals/onboarding-checklist.md` | Add or remove checklist items for your delivery process |
| Pricing tiers | SOW template and service agreement | Define your standard pricing packages |

### What NOT to Change

- **`{{variable}}` placeholder syntax** in templates. The skill's fill logic depends on double-curly-brace placeholders.
- **Template file locations** (`templates/proposals/`). The skill reads from these exact paths.

Try running `/agency-ops:proposal <client-name>` after your next discovery call.

---

## /agency-ops:voice-agent

**Guide voice agent template selection and customization for a client.** *Coming in Phase 4.*

### Design Rationale

- **Assessment-driven recommendation.** Asks about the client's primary pain point, call volume, and current process before recommending one of three use case types (Inbound Receptionist, Speed-to-Lead, Database Reactivation).
- **Platform-agnostic.** Focuses on use case design, not platform-specific configuration. Works whether you use Retell, Vapi, or ElevenLabs.
- **Success metrics built in.** Each use case type includes specific metrics to propose to the client and track post-launch.

### Planned Customization Hooks

| What | Where | How |
|------|-------|-----|
| Use case types | `## Use Case Types` section in `SKILL.md` | Add new voice agent types beyond the current three |
| Assessment questions | `## Use Case Assessment` section in `SKILL.md` | Add follow-up questions for new use case types |
| Success metrics | Each use case's "Success metrics to track" section in `SKILL.md` | Add metrics relevant to your niche |
| Stage-gated advice | `## Stage-Gated Adjustments` section in `SKILL.md` | Customize recommendations per agency stage |

### What NOT to Change

- **Use case type names** (Inbound Receptionist, Speed-to-Lead, Database Reactivation) if other skills or templates reference them.

Phase 4 will add detailed system design document templates with call flow diagrams, integration specs, and platform-specific configuration guides.

---

## /agency-ops:system-build

**Guide system architecture template selection for client automations.** *Coming in Phase 4.*

### Design Rationale

- **Two architecture patterns.** Pre-Call Automation (triggers, routing, agent initiation) and Post-Call Reporting (CRM updates, notifications, follow-up actions). Most projects need both.
- **n8n-focused but tool-agnostic.** Architecture descriptions reference n8n nodes but the patterns work with Make, Zapier, or custom code.
- **Build time estimates.** Each architecture type includes realistic time estimates so you can scope accurately in proposals.

### Planned Customization Hooks

| What | Where | How |
|------|-------|-----|
| Architecture types | `## Architecture Types` section in `SKILL.md` | Add new system patterns beyond pre-call and post-call |
| n8n node recommendations | Each architecture's "Required n8n nodes" section in `SKILL.md` | Update for your preferred automation tool |
| Build time estimates | Each architecture's "Estimated build time" section in `SKILL.md` | Adjust based on your experience and efficiency |
| Testing checklist | Each architecture's "Testing approach" section in `SKILL.md` | Add test cases specific to your common integrations |

### What NOT to Change

- **Architecture type names** (Pre-Call Automation, Post-Call Reporting) if referenced in proposals or SOPs.

Phase 4 will add importable n8n workflow JSON templates and step-by-step build guides.

---

## /agency-ops:lead-gen

**Guide lead generation pipeline setup for your niche.** *Coming in Phase 4.*

### Design Rationale

- **Niche-specific search terms.** Provides recommended Google Maps search queries tailored to each niche (dental, med spa, roofing, HVAC, law firms, real estate).
- **Apify-based scraping with quality filtering.** Recommends filtering by review count, website presence, phone number, and chain detection to find ideal prospects.
- **Cost transparency.** Includes Apify credit estimates so you know what lead generation costs before starting.
- **Feeds directly into outreach.** Designed to produce leads that you track with `/agency-ops:outreach`.

### Planned Customization Hooks

| What | Where | How |
|------|-------|-----|
| Search terms by niche | `## Lead Generation Approaches > ### Google Maps Scraping` table in `SKILL.md` | Add niches or modify search queries |
| Filtering criteria | "Filtering criteria" section in `SKILL.md` | Adjust review thresholds, add exclusion rules |
| Volume targets | `## Pipeline Assessment > ### Question 3` in `SKILL.md` | Change the suggested volume ranges per stage |
| Complementary approaches | `## Lead Generation Approaches > ### Complementary Approaches` in `SKILL.md` | Add new lead sources (e.g., Yelp scraping, trade show lists) |

### What NOT to Change

- **Outreach file format compatibility.** Leads generated here should match the format expected by `/agency-ops:outreach add`.

Phase 4 will add Apify actor configuration templates, automated filtering scripts, and n8n integration for scrape-to-outreach automation.

---

Made some changes? Try running the skill to see the difference. Then get back to `/agency-ops:outreach` -- Dashboard doesn't get clients -- messages do.
