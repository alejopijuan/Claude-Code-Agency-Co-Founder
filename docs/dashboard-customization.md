# Dashboard Customization Guide

> Your dashboard should feel like YOURS. This guide shows you how to make it reflect your agency's brand and workflow.

Got a big idea? Tell Claude about it -- it will capture it to your backlog (`context/customization-backlog.md`) and redirect you back to what matters. Then get back to `/agency-ops:outreach`. Dashboard doesn't get clients -- messages do.

---

## Quick Wins (5 minutes each)

These are easy changes you can make right now by editing `dashboard/index.html`.

### Change Your Agency Name and Branding

The dashboard title lives in the `<header>` element. Find this line in `dashboard/index.html`:

```html
<h1 class="text-xl font-bold text-gray-900">Agency Dashboard</h1>
```

Replace `Agency Dashboard` with your agency name:

```html
<h1 class="text-xl font-bold text-gray-900">Amplify Voice AI Dashboard</h1>
```

You can also update the browser tab title by changing the `<title>` tag in the `<head>`:

```html
<title>Amplify Voice AI Dashboard</title>
```

### Change the Color Scheme

The dashboard uses Tailwind CSS utility classes for colors. The primary accent color is **blue** -- used for the active tab, the refresh button, and the demo banner gradient.

To swap to a different color, search and replace these blue classes in `dashboard/index.html`:

| Find | Replace with (Emerald) | Replace with (Purple) | Replace with (Orange) |
| ---- | ---------------------- | --------------------- | --------------------- |
| `blue-500` | `emerald-500` | `purple-500` | `orange-500` |
| `blue-600` | `emerald-600` | `purple-600` | `orange-600` |
| `blue-800` | `emerald-800` | `purple-800` | `orange-800` |
| `blue-100` | `emerald-100` | `purple-100` | `orange-100` |
| `blue-50` | `emerald-50` | `purple-50` | `orange-50` |
| `indigo-600` | `emerald-700` | `purple-700` | `orange-700` |

**Recommended palettes:**

1. **Emerald** -- Clean, professional. Great for health/dental niches.
2. **Purple** -- Bold, modern. Stands out for tech-forward agencies.
3. **Orange** -- Warm, energetic. Good for home services niches.

### Change the Dashboard Title and Tagline

The demo banner at the top of the page has `id="demo-banner"`:

```html
<div id="demo-banner" class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-4 py-3 text-center text-sm">
  Viewing sample data &mdash; run <code ...>/agency-ops:setup-dashboard</code> to connect your real data
</div>
```

Once you connect Supabase, this banner hides automatically. You can also add your own tagline by inserting a subtitle below the header `<h1>`:

```html
<h1 class="text-xl font-bold text-gray-900">Amplify Voice AI Dashboard</h1>
<p class="text-sm text-gray-500">Your command center for client acquisition</p>
```

---

## Visual Customization

### Colors

Here is a map of which Tailwind classes control what in `dashboard/index.html`:

| Element | Current Classes | What It Controls |
| ------- | --------------- | ---------------- |
| Active tab underline | `border-blue-500` | Blue line under the selected tab |
| Active tab text | `text-blue-600` | Blue text for the selected tab |
| Inactive tab text | `text-gray-500` | Gray text for unselected tabs |
| Refresh button | `text-blue-600 hover:text-blue-800 hover:bg-blue-50` | Blue refresh link in header |
| Demo banner gradient | `bg-gradient-to-r from-blue-600 to-indigo-600` | Blue-to-indigo gradient banner |
| Metric cards | `bg-white rounded-xl shadow-sm border border-gray-100 p-6` | White cards with subtle border |
| Stage badges | `bg-{color}-100 text-{color}-800` per stage (see `STAGE_COLORS` object) | Colored pills for pipeline stages |
| Health dots | `bg-green-500`, `bg-yellow-500`, `bg-red-500` | Small circles on client cards |
| Health text | `text-green-700`, `text-yellow-700`, `text-red-700` | Health label text next to dots |
| Commitment badge | `bg-blue-100 text-blue-800` | Blue pill showing open commitment count |
| Page background | `bg-gray-50` on `<body>` | Light gray page background |

**Example: Switching from blue to emerald theme**

Before:

```html
<button data-tab="overview" onclick="switchTab('overview')" class="tab-btn border-b-2 border-blue-500 text-blue-600 ...">Overview</button>
```

After:

```html
<button data-tab="overview" onclick="switchTab('overview')" class="tab-btn border-b-2 border-emerald-500 text-emerald-600 ...">Overview</button>
```

Also update the `switchTab()` function in the `<script>` section -- find these lines:

```javascript
btn.classList.toggle('border-blue-500', isActive);
btn.classList.toggle('text-blue-600', isActive);
```

Replace with:

```javascript
btn.classList.toggle('border-emerald-500', isActive);
btn.classList.toggle('text-emerald-600', isActive);
```

### Typography

The dashboard uses Tailwind's default font stack (Inter/system fonts). To add a custom Google Font:

1. Add a CDN link in the `<head>` section of `dashboard/index.html`, after the Tailwind script:

```html
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
```

2. Add a Tailwind config override right after the `<script src="https://cdn.tailwindcss.com"></script>` line:

```html
<script>
  tailwind.config = {
    theme: {
      extend: {
        fontFamily: {
          sans: ['Plus Jakarta Sans', 'system-ui', 'sans-serif'],
        }
      }
    }
  }
</script>
```

### Layout

**Reorder tabs:** The tab buttons are in the `<nav>` element. Change the HTML order to change the display order:

```html
<nav class="bg-white border-b border-gray-200 px-6 overflow-x-auto">
  <div class="flex space-x-8 -mb-px">
    <button data-tab="overview" ...>Overview</button>
    <button data-tab="outreach" ...>Outreach</button>
    <button data-tab="pipeline" ...>Pipeline</button>
    <button data-tab="clients" ...>Clients</button>
  </div>
</nav>
```

Just reorder the `<button>` elements. Also reorder the matching `<div data-tab-content="...">` sections in `<main>` to keep them consistent.

**Change grid layout for metric cards:** The Overview tab uses `grid grid-cols-1 md:grid-cols-3 gap-4` for a 3-column grid on medium+ screens. To show 4 columns on large screens:

```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
```

**Change client card layout:** Client cards use `grid grid-cols-1 lg:grid-cols-3 gap-4`. For a 2-column layout:

```html
<div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
```

---

## Functional Customization

### Adding a New Metric Card

The Overview tab renders metric cards in the `renderOverview()` function. Each card is generated by the `metricCard()` helper:

```javascript
function metricCard(label, value, sub) {
  return `<div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
    <p class="text-sm font-medium text-gray-500 mb-1">${label}</p>
    <p class="text-3xl font-bold text-gray-900">${value}</p>
    ${sub ? `<p class="text-xs text-gray-400 mt-1">${sub}</p>` : ''}
  </div>`;
}
```

**Step-by-step: Add an "Average Deal Size" card**

1. In the `renderOverview()` function, after the existing metric calculations, add:

```javascript
const avgDealSize = activeDeals.length > 0
  ? Math.round(pipelineValue / activeDeals.length)
  : 0;
```

2. Add the new card to the Pipeline and Revenue grid. Find the line with:

```javascript
${metricCard('Monthly Revenue', formatCurrency(monthlyRevenue) + '/mo', 'Recurring revenue')}
```

And add after it (inside the same grid div):

```javascript
${metricCard('Avg Deal Size', formatCurrency(avgDealSize) + '/mo', 'Per active deal')}
```

3. Since you now have 4 cards in that grid, update the grid to 4 columns:

```javascript
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
```

### Changing Chart Types

The Outreach tab uses a horizontal bar chart (`indexAxis: 'y'`) for the funnel. The Chart.js configuration is in the `renderOutreachTab()` function.

**Switch to vertical bars:** Remove `indexAxis: 'y'` from the options:

```javascript
// Before
options: {
  indexAxis: 'y',
  responsive: true,
  ...
}

// After
options: {
  responsive: true,
  ...
}
```

**Add a doughnut chart for stage distribution:** Add a new canvas element and chart instance. In the outreach content HTML:

```javascript
container.innerHTML = `
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 mb-4">
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
      <h2 class="text-lg font-semibold text-gray-900 mb-4">Outreach Funnel</h2>
      <div class="chart-container"><canvas id="funnelCanvas"></canvas></div>
    </div>
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
      <h2 class="text-lg font-semibold text-gray-900 mb-4">Stage Distribution</h2>
      <div class="chart-container"><canvas id="stageDonutCanvas"></canvas></div>
    </div>
  </div>`;
```

Then create the doughnut chart after the existing funnel chart:

```javascript
new Chart(document.getElementById('stageDonutCanvas').getContext('2d'), {
  type: 'doughnut',
  data: {
    labels: STAGES.map(s => STAGE_LABELS[s]),
    datasets: [{
      data: stageCounts,
      backgroundColor: STAGES.map(s => STAGE_COLORS[s].chart),
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    plugins: { legend: { position: 'bottom' } }
  }
});
```

### Adding a New Data Panel

To add a new tab (for example, "Tasks"):

1. **Add a tab button** in the `<nav>` section:

```html
<button data-tab="tasks" onclick="switchTab('tasks')" class="tab-btn border-b-2 border-transparent text-gray-500 hover:text-gray-700 px-1 py-3 text-sm font-medium whitespace-nowrap">Tasks</button>
```

2. **Add a content div** in `<main>`:

```html
<div data-tab-content="tasks" class="hidden">
  <div id="tasks-content"></div>
  <div id="tasks-empty" class="hidden text-center py-16 text-gray-400">
    <p class="text-lg mb-2">No tasks yet</p>
  </div>
</div>
```

3. **Add a render function** in the `<script>` section:

```javascript
function renderTasksTab(deals, clients) {
  const container = document.getElementById('tasks-content');
  // Your custom rendering logic here
  container.innerHTML = `<div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
    <h2 class="text-lg font-semibold text-gray-900 mb-4">Tasks</h2>
    <!-- Task list here -->
  </div>`;
}
```

4. **Call it from `initDashboard()`:**

```javascript
renderTasksTab(deals, clients);
```

The `switchTab()` function uses `data-tab` and `data-tab-content` attributes, so it will handle the new tab automatically -- no changes needed to the tab switching logic.

---

## Supabase Customization

### Adding a New Column

If you want to track a new field (for example, `lead_score` on leads):

1. **Add the column in Supabase SQL Editor:**

```sql
ALTER TABLE leads ADD COLUMN lead_score integer DEFAULT 0;
```

2. **Update the DataSource query** in `dashboard/index.html`. The `getLeads()` method uses `select('*')`, so the new column is already fetched automatically.

3. **Update the render function** to display it. In `renderOutreachTab()`, add it to the table or card where you want it to appear.

4. **Update demo data** if you want it to show in demo mode. In `generateDemoLeads()`, add `lead_score` to each demo lead object:

```javascript
{ name: 'Sarah Mitchell', company: 'Bright Smile Dental', lead_score: 85, ... }
```

5. **Update dual-write skills.** If you want skills to populate this field, update the relevant SKILL.md's Supabase Sync section to include the new field in the JSON payload.

### Custom Queries

The `DataSource` object in `dashboard/index.html` has three methods: `getLeads()`, `getDeals()`, and `getClients()`. Each uses the Supabase JavaScript client.

**Filter leads to last 30 days:**

```javascript
async getLeads() {
  if (this.mode === 'demo') return generateDemoLeads();
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
  const { data, error } = await this.supabase
    .from('leads')
    .select('*')
    .gte('last_contact', thirtyDaysAgo.toISOString().split('T')[0])
    .order('last_contact', { ascending: false });
  return error ? generateDemoLeads() : data;
}
```

**Show only active deals (exclude closed):**

```javascript
async getDeals() {
  if (this.mode === 'demo') return generateDemoDeals();
  const { data, error } = await this.supabase
    .from('deals')
    .select('*')
    .neq('stage', 'closed')
    .order('last_updated', { ascending: false });
  return error ? generateDemoDeals() : data;
}
```

**Add a new DataSource method** for a custom table:

```javascript
async getTasks() {
  if (this.mode === 'demo') return [];
  const { data, error } = await this.supabase
    .from('tasks')
    .select('*')
    .order('due_date', { ascending: true });
  return error ? [] : data;
}
```

---

## What NOT to Change

These conventions are used by skills for data integration. Changing them will break the connection between your skills and the dashboard.

**YAML frontmatter field names in client/lead/deal files:**
Skills write to Supabase using these exact field names from markdown frontmatter. If you rename a field in the template, the dual-write will send the wrong data.

**Supabase table names and column names:**
The tables `leads`, `deals`, and `clients` are referenced by name in every skill's Supabase Sync section. Renaming them requires updating every SKILL.md.

**localStorage keys:**
The dashboard reads credentials from `localStorage.getItem('supabase_url')` and `localStorage.getItem('supabase_anon_key')`. The setup-dashboard skill writes to these exact keys. Changing the key names breaks the connection.

**DataSource method signatures:**
`getLeads()`, `getDeals()`, and `getClients()` return arrays of objects with specific field names. Future skills or dashboard extensions may depend on these signatures.

---

Ideas? Tell Claude! When you think of something you want to see, just mention it in any conversation. Claude will capture it to your customization backlog (`context/customization-backlog.md`) and redirect you back to what matters.
