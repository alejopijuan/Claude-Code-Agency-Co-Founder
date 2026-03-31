---
name: agency-ops:new-client
description: Create a new client context file through interactive conversation
argument-hint: "<client-name>"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# New Client Setup

I'll help you set up a context file for your new client. I'll ask a few questions and generate a complete client file you can use with all your agency skills.

## Rules

1. Read `context/agency.md` first to understand the user's agency context (niche, tech stack, communication style). Use this to pre-fill sensible defaults.
2. Read `context/clients/_template.md` for the file structure to follow.
3. Use `AskUserQuestion` for each question individually -- do not batch questions.
4. If `$ARGUMENTS` is provided, use it as the client name and skip the client name question.
5. Generate the client file as soon as you have enough info (name + industry minimum). Ask remaining optional questions after initial generation if the user wants to continue.
6. Fill in sensible defaults for skipped fields based on the agency's context from `context/agency.md`.

## Questions

Ask in this order. Mark required questions clearly to the user.

### Required

1. **Client/company name** -- Who is this client? (Skip if provided via `$ARGUMENTS`)
2. **Industry/niche** -- What industry are they in? (dental, roofing, med spa, law firm, HVAC, etc.)
3. **Project description** -- What are you building for them? Brief description of the engagement.
4. **Use case type** -- What kind of voice AI solution?
   - Inbound receptionist (answer calls, route, schedule)
   - Speed-to-lead (missed call callback within 60 seconds)
   - Database reactivation (re-engage past customers)
   - Other (describe)

### Optional (offer to continue after generating the file)

5. **Voice AI platform** -- Which platform for this project? (Default: use agency's platform from `context/agency.md`)
6. **Key contact name and email** -- Who is your main point of contact? (Can add later)
7. **Monthly value / pricing** -- What's the monthly value of this engagement? (Can add later)
8. **Meeting cadence** -- How often do you meet? (Default: biweekly)
   - Weekly
   - Biweekly
   - Monthly
9. **Communication channel** -- How do they prefer to communicate? (Slack, email, phone)

## File Generation

After collecting the required answers:

1. **Generate filename:** Lowercase, hyphenated version of the client name.
   - "Sunrise Dental" becomes `sunrise-dental.md`
   - "Dr. Smith's Practice" becomes `dr-smiths-practice.md`

2. **Write the file** to `context/clients/{filename}.md` following the exact structure from `context/clients/_template.md`.

3. **Set these fields:**
   - `last_updated`: today's date in ISO 8601 format (YYYY-MM-DD)
   - `start_date`: today's date in ISO 8601 format
   - `staleness_threshold_days: 14`
   - `status: active`
   - `meeting_cadence`: user's answer or default "biweekly"
   - `monthly_value`: user's answer or default 0

4. **Initialize the Commitments Log** with table headers and one initial entry:

   | Date | Commitment | Owner | Status | Due |
   |------|------------|-------|--------|-----|
   | {today} | Initial setup and onboarding | {agency_name from agency.md} | In Progress | {today + 14 days} |

5. **Replace all `{{variable}}` placeholders** with actual values. The generated file must NOT contain any `{{}}` template variables.

## After Generation

1. **Show the user a summary** of the created file:
   - Client name and industry
   - Project scope and use case
   - File location
   - What defaults were applied

2. **Update agency.md:** Read `context/agency.md` and update the `## Clients Summary` section to include the new client. Add a line like:
   - `- {client_name} ({industry}) -- {project_description} | Status: active`

3. **Suggest next steps:**
   - "Run `/agency-ops:client-briefing {client-name}` to generate your first briefing"
   - "Run `/agency-ops:meeting-prep {client-name}` before your next meeting"
   - "You can always edit `context/clients/{filename}.md` directly to add more details"

## Supabase Sync

After generating the client file and completing all steps above:

1. Read `supabase_url` and `supabase_anon_key` from `context/agency.md` frontmatter (already read at the start of this skill).
2. If either field is missing, empty, or contains `{{`, skip this section entirely.
3. Construct a JSON object from the new client file's YAML frontmatter fields: name, industry, status, monthly_value, start_date, meeting_cadence, last_updated, staleness_threshold_days, open_commitments_count, next_meeting_date.
4. Use Bash to execute:
   ```
   curl -s -L -X POST "{supabase_url}/rest/v1/clients" \
     -H "apikey: {supabase_anon_key}" \
     -H "Authorization: Bearer {supabase_anon_key}" \
     -H "Content-Type: application/json" \
     -H "Prefer: resolution=merge-duplicates" \
     -d '{json_object}'
   ```
5. If curl fails, show brief note: "Dashboard sync skipped -- your client data is saved in markdown." Continue normally. Do NOT retry.

Refer to `.claude/commands/agency-ops/setup-dashboard/references/dual-write-guide.md` for full details on the Supabase sync pattern.
