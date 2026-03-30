---
name: agency-ops:lead-gen
description: Guide lead generation pipeline setup for your niche
argument-hint: ""
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Lead Generation Guide

I'll help you set up a lead generation pipeline for your niche. We'll figure out who to target, how to find them, and how to build a repeatable system for filling your outreach pipeline.

## Rules

1. Read `context/agency.md` to understand the user's agency context (niche, stage, target market).
2. Read this skill's `learnings.md` for any accumulated preferences or patterns.
3. No client argument needed -- this skill is about finding NEW leads, not working with existing clients.
4. If the user has an existing outreach directory (`context/outreach/`), scan it to understand what niches and channels they are already working.

## Pipeline Assessment

Ask the user about their lead generation needs to recommend the right approach. Use `AskUserQuestion` for each question individually.

### Question 1: Target Niche

"What niche are you targeting for lead generation?"
- Dental practices
- Medical spas / aesthetics
- Roofing companies
- HVAC / home services
- Law firms
- Real estate agencies
- Other (describe)

If the user's `agency.md` already specifies a niche, confirm it: "I see you're focused on [niche]. Are you looking for leads in that niche, or exploring a new one?"

### Question 2: Geographic Focus

"What city or region are you targeting?"
- Specific city (e.g., "Miami" or "Denver metro area")
- Specific state or region
- Multiple cities (list them)
- National (not recommended for starting out -- suggest narrowing down)

### Question 3: Volume and Cadence

"How many new leads do you need per week?"
- 5-10 (starting out, testing messaging)
- 10-25 (active outreach, building pipeline)
- 25-50 (scaling, multiple outreach channels)
- 50+ (high volume, likely need automation)

## Lead Generation Approaches

Based on the assessment, recommend the right approach:

### Google Maps Scraping (Rankwell V2 Pattern)

**Best for:** Local businesses in any service niche -- dental, roofing, HVAC, med spa, law firms, auto repair, restaurants.

**How it works:**
1. Define search terms based on the user's niche and location (e.g., "dentist Miami FL", "HVAC contractor Denver CO").
2. Use Apify's Google Maps scraper to extract business listings.
3. Filter results by quality signals: minimum review count, has a website, has a phone number, not a chain/franchise.
4. Score leads by fit: businesses with 50-200 reviews are ideal (established but not too big), negative reviews mentioning "couldn't reach" or "no one answered" signal missed-call pain.
5. Export filtered list for outreach via `/agency-ops:outreach`.

**Recommended search terms by niche:**

| Niche | Primary Search | Secondary Search |
|-------|---------------|-----------------|
| Dental | "dentist [city]", "dental office [city]" | "cosmetic dentist [city]", "family dentist [city]" |
| Med Spa | "med spa [city]", "medspa [city]" | "botox [city]", "aesthetics clinic [city]" |
| Roofing | "roofing company [city]", "roofer [city]" | "roof repair [city]", "roofing contractor [city]" |
| HVAC | "HVAC [city]", "air conditioning [city]" | "heating repair [city]", "AC company [city]" |
| Law Firms | "personal injury lawyer [city]", "law firm [city]" | "family lawyer [city]", "criminal defense [city]" |
| Real Estate | "real estate agent [city]", "realtor [city]" | "property management [city]" |

**Estimated lead volume:** A single city search typically returns 50-200 results before filtering. After quality filtering, expect 20-60 viable leads per search.

**Apify cost estimate:** Google Maps scraper runs cost approximately $1-3 per 100 results. A typical monthly pipeline of 200 leads costs around $5-10 in Apify credits.

**Filtering criteria (recommended defaults):**
- Has a website (required -- you need to research them before outreach)
- Has a phone number (required -- voice AI needs a phone system)
- Minimum 10 Google reviews (indicates established business)
- Maximum 500 reviews (too large = corporate decision-making, harder to close)
- Not a franchise or national chain (check business name against known chains)
- No existing chatbot or AI visible on website (quick manual check during outreach)

### Complementary Approaches

**LinkedIn Search (manual, no scraping):**
- Search for business owners or office managers in the target niche and city.
- Use connection notes to introduce yourself (templates available via `/agency-ops:outreach`).
- Best paired with Google Maps data -- find the business on Maps, then find the owner on LinkedIn for a warm approach.

**Referral Mining:**
- Ask existing clients: "Do you know any other [niche] owners who struggle with [missed calls / slow lead response]?"
- Offer a referral incentive (one month free, gift card, etc.).
- Highest conversion rate of any lead source, but low volume.

## Recommendation Output

After the assessment, provide the user with:

1. **Recommended search terms** tailored to their specific niche and geographic focus.
2. **Estimated lead volume** based on their niche and city size.
3. **Filtering criteria** customized for their niche (some niches have different review thresholds or red flags).
4. **Cost estimate** for Apify credits based on their target volume.
5. **Suggested outreach workflow:**
   - Scrape leads weekly (or bi-weekly).
   - Filter and score new leads.
   - Add top leads to outreach tracking with `/agency-ops:outreach`.
   - Follow the 3-5-7-14 day follow-up cadence.
6. **Quick start steps:**
   - Sign up for Apify (free tier includes enough credits to start).
   - Run the first scrape with the recommended search terms.
   - Review results and adjust filtering criteria.
   - Pick the top 10 leads and start outreach.

## Phase 4 Note

Detailed lead gen pipeline templates with Apify actor configuration, automated filtering scripts, cost breakdowns by niche, and integration with n8n for automated scrape-to-outreach workflows are coming in Phase 4.

For now, use this guidance to plan your approach, run manual scrapes via Apify's web interface, and start tracking leads with `/agency-ops:outreach`.

## Stage-Gated Adjustments

- **Starting out (0 clients):** Focus on ONE niche in ONE city. Get 20-30 leads, work through them all before scraping more. The goal is to find your first client, not build a massive pipeline. Manual Apify runs are fine at this stage.
- **Getting traction (1-3 clients):** Expand to 2-3 cities in the same niche. Increase volume to 50-100 leads per month. Start tracking conversion rates (leads to replies, replies to calls, calls to clients) to optimize your targeting.
- **Scaling (5+ clients):** Automate the scrape-to-outreach pipeline with n8n (Phase 4 templates). Expand to multiple niches if your delivery model supports it. Consider hiring a VA to handle initial outreach while you focus on discovery calls.

## Learnings Update

After completing the assessment, append a learning entry to this skill's `learnings.md`:

```markdown
- **[date]** [tag:lead-gen] [niche/city context]: [what was recommended, search terms that worked, filtering adjustments, any user feedback]
```

Keep entries concise. Focus on niche-specific insights (e.g., "dental in Miami: 180 results, filtered to 45 viable leads. Exclude orthodontists -- they have different decision-making structure").
