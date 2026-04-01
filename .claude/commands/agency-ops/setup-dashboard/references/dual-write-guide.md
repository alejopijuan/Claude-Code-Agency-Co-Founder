# Dual-Write Guide

Skills write markdown first (always), then optionally sync to Supabase via curl. Markdown is the source of truth. Supabase is a read-optimized mirror that powers the dashboard.

If Supabase is not configured, skills work exactly the same -- they just skip the sync step.

## Detection

Before attempting a Supabase sync, check if credentials are configured:

1. Read `context/agency.md` YAML frontmatter
2. Check that `supabase_url` field exists and is not empty
3. Check that `supabase_anon_key` field exists and is not empty
4. Verify neither field contains `{{` (which means it is still a template placeholder)

If any check fails, skip the Supabase sync silently. Do not warn the user or suggest setup -- the skill should work seamlessly without Supabase.

## curl Template

Use this exact curl command to upsert data to Supabase:

```bash
curl -s -L -X POST "{supabase_url}/rest/v1/{table}" \
  -H "apikey: {supabase_anon_key}" \
  -H "Authorization: Bearer {supabase_anon_key}" \
  -H "Content-Type: application/json" \
  -H "Prefer: resolution=merge-duplicates" \
  -d '{json_payload}'
```

Replace:
- `{supabase_url}` -- Project URL from `agency.md` frontmatter (e.g., `https://xxxx.supabase.co`)
- `{supabase_anon_key}` -- Anon/public key from `agency.md` frontmatter
- `{table}` -- One of: `leads`, `deals`, `clients`
- `{json_payload}` -- JSON object or array matching the table columns

## Table Mapping

| Markdown Directory | Supabase Table | Unique Key |
|---|---|---|
| `context/outreach/` | `leads` | (name, company) |
| `context/pipeline/` | `deals` | (name) |
| `context/clients/{name}/{name}.md` | `clients` | (name) |

## Field Mapping Per Table

### Leads (context/outreach/ -> leads)

| YAML Frontmatter Field | Supabase Column | Type |
|---|---|---|
| name | name | TEXT |
| company | company | TEXT |
| channel | channel | TEXT |
| stage | stage | TEXT |
| source | source | TEXT |
| last_contact | last_contact | DATE |
| next_follow_up | next_follow_up | DATE |

### Deals (context/pipeline/ -> deals)

| YAML Frontmatter Field | Supabase Column | Type |
|---|---|---|
| name | name | TEXT |
| contact | contact | TEXT |
| outreach_file | outreach_file | TEXT |
| stage | stage | TEXT |
| niche | niche | TEXT |
| value | value | INTEGER |
| next_action | next_action | TEXT |
| created | created | DATE |
| last_updated | last_updated | DATE |

### Clients (context/clients/ -> clients)

| YAML Frontmatter Field | Supabase Column | Type |
|---|---|---|
| name | name | TEXT |
| industry | industry | TEXT |
| status | status | TEXT |
| monthly_value | monthly_value | INTEGER |
| start_date | start_date | DATE |
| meeting_cadence | meeting_cadence | TEXT |
| last_updated | last_updated | DATE |
| staleness_threshold_days | staleness_threshold_days | INTEGER |
| open_commitments_count | open_commitments_count | INTEGER |
| next_meeting_date | next_meeting_date | DATE |

## Error Handling

If the curl command fails or returns an error:

1. Show a brief note: "Dashboard sync skipped -- your data is saved in markdown."
2. Do NOT retry the request
3. Do NOT block skill completion
4. Continue with the skill's summary and learnings update as normal

The user's data is always safe in markdown. Supabase sync is best-effort.

## How Upsert Works

The `Prefer: resolution=merge-duplicates` header tells PostgREST to perform an upsert:

- If a row with the same unique key already exists, it updates the existing row with the new values
- If no matching row exists, it inserts a new row

Unique keys by table:
- **Leads:** Matched on `(name, company)` -- same person at the same company updates instead of duplicating
- **Deals:** Matched on `(name)` -- same deal name updates instead of duplicating
- **Clients:** Matched on `(name)` -- same client name updates instead of duplicating

This means skills can always POST the full record without checking if it exists first. Supabase handles the insert-or-update logic automatically.
