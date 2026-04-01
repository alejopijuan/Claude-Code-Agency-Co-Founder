---
name: agency-ops:setup-dashboard
description: Connect your agency dashboard to Supabase for live data visualization
argument-hint: "[reconnect]"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Dashboard Setup

I'll connect your dashboard to Supabase so it shows your real outreach, pipeline, and client data instead of demo data.

## Rules

1. Read `context/agency.md` first to check if already configured (supabase_url field present and not containing `{{`).
2. Read this skill's `learnings.md` before proceeding.
3. If already configured AND `$ARGUMENTS` is not "reconnect", offer three options via `AskUserQuestion`: (a) Verify connection works, (b) Reconnect with new credentials, (c) Exit.
4. If `$ARGUMENTS` is "reconnect" or user chose reconnect, proceed with fresh setup.
5. Use `AskUserQuestion` for each question individually -- do not batch questions.
6. Reliability is paramount -- if anything fails, always have a clear recovery path.

## Path Detection

Detect whether the Playwright MCP browser automation tools are available:

1. Try to use the `browser_navigate` tool to go to `https://supabase.com`.
2. If the tool is available and works, proceed with the **Playwright Path** below.
3. If the tool is not available (tool-not-found error or similar), proceed with the **Manual Path** below.

Do NOT hard-check MCP configuration files -- just try and fall back gracefully. Partial automation is always fine.

## Playwright Path

Estimated time: 3-5 minutes. This path automates most of the Supabase setup through the browser.

### Step 1: Navigate to Supabase

Use `browser_navigate` to go to `https://supabase.com/dashboard`.

### Step 2: User signs in

Tell the user: "Please sign in or create a Supabase account. I'll wait while you do this -- I can see the browser but I'll never type your credentials."

Use `AskUserQuestion`: "Let me know when you're signed in to Supabase."

### Step 3: Verify login

Take a screenshot with `browser_snapshot` to verify the user is logged in and on the dashboard.

### Step 4: Create new project

Click "New Project" using `browser_click`. Automate the project creation form:
- **Project name:** Use the `agency_name` from `context/agency.md` + "-dashboard" (e.g., "Amplify Voice AI-dashboard")
- **Password:** Generate a random secure password using Bash: `openssl rand -base64 24`
- **Region:** Select the region closest to the user (ask via `AskUserQuestion` if unclear, default to US East)

Use `browser_type` to fill in form fields and `browser_click` to submit.

### Step 5: Wait for provisioning

Tell the user: "Your Supabase project is being created. This usually takes about 2 minutes."

Take periodic screenshots with `browser_snapshot` every 30 seconds to check progress. Wait until the project dashboard loads.

### Step 6: Navigate to SQL Editor

Use `browser_click` to navigate to the SQL Editor in the left sidebar.

### Step 7: Run schema SQL

Read the SQL from this skill's `references/supabase-schema.sql` file. Paste the entire SQL into the SQL Editor using `browser_type` or `browser_run_code`. Click "Run" to execute it.

Take a screenshot to verify the SQL ran successfully.

### Step 8: Navigate to API settings

Use `browser_click` to navigate to Settings > API in the left sidebar.

### Step 9: Extract credentials

Use `browser_snapshot` to capture the API settings page. Extract:
- **Project URL** (looks like `https://xxxx.supabase.co`)
- **anon/public key** (long string starting with `eyJ...`)

### Step 10: Store credentials

Proceed to the **Credential Storage** section below with the extracted URL and key.

### Step 11: Initial sync

Proceed to the **Bulk Initial Sync** section below.

### Error Recovery

If ANY Playwright step fails (element not found, timeout, navigation error):
1. Inform the user what happened: "Browser automation hit an issue at [step]. Let me switch to manual instructions for the remaining steps."
2. Switch to the **Manual Path** starting from whichever step corresponds to where the error occurred.
3. Partial automation is perfectly fine -- the end result is the same either way.

## Manual Path

Estimated time: 8-12 minutes. This path gives you step-by-step instructions to copy and paste.

### Step 1: Create Supabase account and project

Tell the user:

"Go to https://supabase.com and create an account if you don't have one. Then click 'New Project' to create a new project. You can name it anything -- I'd suggest your agency name + '-dashboard'. Pick a strong password and the region closest to you."

### Step 2: Wait for project

Use `AskUserQuestion`: "Let me know when your Supabase project is ready (this takes about 2 minutes after creation)."

### Step 3: Run schema SQL

Tell the user:

"Go to the **SQL Editor** in the left sidebar of your Supabase dashboard. Copy and paste the following SQL and click **Run**:"

Read the file `.claude/commands/agency-ops/setup-dashboard/references/supabase-schema.sql` and output its entire contents as a fenced SQL code block.

### Step 4: Confirm SQL ran

Use `AskUserQuestion`: "Did the SQL run successfully? You should see a 'Success' message with no errors."

If the user reports errors, help troubleshoot:
- If tables already exist, suggest running `DROP TABLE leads, deals, clients CASCADE;` first, then re-running
- If permission errors, check they are in the SQL Editor (not the Table Editor)

### Step 5: Navigate to API settings

Tell the user: "Now go to **Settings > API** in the left sidebar (look for the gear icon, then 'API' under Configuration)."

### Step 6: Get Project URL

Use `AskUserQuestion`: "Paste your **Project URL** (it looks like https://xxxx.supabase.co):"

Validate the response looks like a Supabase URL (starts with `https://` and contains `.supabase.co`). If it doesn't look right, ask the user to double-check.

### Step 7: Get anon key

Use `AskUserQuestion`: "Paste your **anon/public key** (the long string starting with eyJ...):"

Validate the response starts with `eyJ`. If it doesn't, ask the user to check they copied the anon key (not the service_role key).

### Step 8: Store credentials

Proceed to the **Credential Storage** section below with the provided URL and key.

### Step 9: Initial sync

Proceed to the **Bulk Initial Sync** section below.

## Credential Storage

Store the Supabase credentials in two places: `agency.md` (for skills to read) and `localStorage` (for the dashboard to read).

### 1. Update agency.md

Read the current content of `context/agency.md`. Add `supabase_url` and `supabase_anon_key` fields to the YAML frontmatter, after the existing fields and before the closing `---`. Use double-quoted strings matching the existing style:

```yaml
---
agency_name: "Existing Agency Name"
stage: "getting-traction"
niche: "dental"
last_updated: "2026-03-31"
supabase_url: "https://xxxx.supabase.co"
supabase_anon_key: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
---
```

Do NOT modify any other fields in the frontmatter or body. Only add the two new fields.

### 2. Provide localStorage snippet

Generate a JavaScript snippet with the actual credentials filled in and show it to the user:

```javascript
localStorage.setItem('supabase_url', '{actual_url}');
localStorage.setItem('supabase_anon_key', '{actual_key}');
```

Tell the user:

"Open `dashboard/index.html` in your browser, press **Cmd+Option+J** (Mac) or **Ctrl+Shift+J** (Windows) to open the browser console, paste this code, then press Enter and refresh the page."

## Bulk Initial Sync

Sync existing markdown data to Supabase so the dashboard shows current state immediately.

### Leads (context/outreach/)

Read all files in `context/outreach/` excluding `_template.md`. For each file, parse the YAML frontmatter and extract: `name`, `company`, `channel`, `stage`, `source`, `last_contact`, `next_follow_up`. Build a JSON array of all leads.

### Deals (context/pipeline/)

Read all files in `context/pipeline/` excluding `_template.md`. For each file, parse the YAML frontmatter and extract: `name`, `contact`, `outreach_file`, `stage`, `niche`, `value`, `next_action`, `created`, `last_updated`. Build a JSON array of all deals.

### Clients (context/clients/)

Read the main `.md` file from each subdirectory in `context/clients/`. List subdirs with `ls -d context/clients/*/`, then read `{dir}/{dir-basename}.md` for each. Exclude any files at the root level like `_template.md`. For each client file, parse the YAML frontmatter and extract: `name`, `industry`, `status`, `monthly_value`, `start_date`, `meeting_cadence`, `last_updated`, `staleness_threshold_days`, `open_commitments_count`, `next_meeting_date`. Build a JSON array of all clients.

### Execute sync

For each non-empty array, use `Bash` to execute a single curl POST with the array as the JSON payload:

```bash
curl -s -L -X POST "{supabase_url}/rest/v1/{table}" \
  -H "apikey: {anon_key}" \
  -H "Authorization: Bearer {anon_key}" \
  -H "Content-Type: application/json" \
  -H "Prefer: resolution=merge-duplicates" \
  -d '[{json_array}]'
```

Report results to the user: "Synced X leads, Y deals, Z clients to your dashboard."

If any sync fails, note it but do not block: "Some records couldn't sync. They'll sync next time you use the relevant skill."

If no markdown files exist (fresh install with no real data), skip the sync and tell the user: "No existing data to sync. Your dashboard will populate as you use /outreach, /pipeline, and /new-client."

## Verification

Use `AskUserQuestion`: "Open `dashboard/index.html` in your browser and refresh. Do you see your real data instead of the demo banner?"

**If yes:** "You're all set! From now on, skills that create leads, deals, or clients will automatically sync to your dashboard. Just refresh the page to see new data."

**If no:** Troubleshoot:
1. Check localStorage is set: ask user to run `console.log(localStorage.getItem('supabase_url'))` in browser console
2. Verify Supabase URL is accessible: use Bash to curl the URL
3. Check Supabase table has data: `curl -s "{supabase_url}/rest/v1/leads?select=count" -H "apikey: {key}"` 
4. Suggest opening browser console (Cmd+Option+J) and looking for error messages
5. If all else fails, offer to re-run the setup with `/agency-ops:setup-dashboard reconnect`

## Post-Setup Summary

Tell the user what happened and how things work going forward:

1. **What happened:** Supabase project created, schema deployed (leads/deals/clients tables), credentials stored in `agency.md` and browser localStorage, existing data synced.
2. **How it works going forward:** Skills that create or update leads, deals, or clients will automatically sync to Supabase after writing to markdown (see `references/dual-write-guide.md` for the pattern). Markdown is always the source of truth.
3. **How to refresh:** Just refresh the browser page -- the dashboard reads live from Supabase on every load.
4. **How to reconnect:** Run `/agency-ops:setup-dashboard reconnect` to set up a new Supabase project or update credentials.

## Learnings Update

After completing setup (or if the user encountered issues):

1. Read `learnings.md` from this skill's directory.
2. If the user encountered issues, preferences, or gave feedback, append a new entry under the appropriate section (Preferences for lasting preferences, Situational for one-time context).
3. Format: `- [{date}] {learning}` (e.g., `- [2026-03-31] User preferred manual path over Playwright automation`)
4. Check `max_entries` (30). If approaching the limit, consolidate older entries into the Pruned section.
