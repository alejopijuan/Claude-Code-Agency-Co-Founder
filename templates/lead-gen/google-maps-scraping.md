# Lead Generation via Google Maps Scraping (Optional Reference)

This is a supplementary reference for users who specifically want to set up a scraping-based lead pipeline. It is NOT the default recommendation -- see the Lead Generation Strategy Guide for the recommended approach (referrals, partnerships, outreach, content marketing, networking).

## How It Works

Google Maps -> Apify scraper -> filter -> score -> export

1. Define search terms based on your niche and target city.
2. Use Apify's Google Maps scraper to extract business listings.
3. Filter results by quality signals (website, phone, review count, not a chain).
4. Score leads by fit (review count sweet spot, negative review signals).
5. Export filtered list for outreach via `/agency-ops:outreach`.

## Recommended Search Terms by Niche

Customize {{target_niche}} and {{target_city}} for your market.

| Niche | Primary Search | Secondary Search |
|-------|---------------|-----------------|
| Dental | "dentist {{target_city}}", "dental office {{target_city}}" | "cosmetic dentist {{target_city}}", "family dentist {{target_city}}" |
| Med Spa | "med spa {{target_city}}", "medspa {{target_city}}" | "botox {{target_city}}", "aesthetics clinic {{target_city}}" |
| Roofing | "roofing company {{target_city}}", "roofer {{target_city}}" | "roof repair {{target_city}}", "roofing contractor {{target_city}}" |
| HVAC | "HVAC {{target_city}}", "air conditioning {{target_city}}" | "heating repair {{target_city}}", "AC company {{target_city}}" |
| Law Firms | "personal injury lawyer {{target_city}}", "law firm {{target_city}}" | "family lawyer {{target_city}}", "criminal defense {{target_city}}" |
| Real Estate | "real estate agent {{target_city}}", "realtor {{target_city}}" | "property management {{target_city}}" |

## Filtering Criteria

Apply these filters to raw scraping results. Adjust {{min_reviews}} and {{max_reviews}} for your niche.

| Filter | Default | Why |
|--------|---------|-----|
| Has website | Required | You need to research them before outreach |
| Has phone number | Required | Voice AI needs a phone system |
| Minimum reviews | {{min_reviews}} (default: 10) | Indicates established business |
| Maximum reviews | {{max_reviews}} (default: 500) | Too large = corporate decision-making, harder to close |
| Not a franchise | Exclude known chains | National chains have centralized IT, not your target |
| No existing chatbot | Manual check during outreach | Indicates they may already have an AI vendor |

## Scoring Approach

- **50-200 reviews** is the sweet spot: established enough to afford your services, small enough to make decisions quickly.
- **Negative reviews mentioning "couldn't reach" or "no one answered"** are strong signals of missed-call pain -- these businesses are ideal candidates for an inbound receptionist agent.
- **Recent reviews (last 6 months)** indicate the business is active and investing in growth.

## Apify Setup

### Getting Started

1. Sign up at [apify.com](https://apify.com) (free tier available).
2. Search for the **"Google Maps Scraper"** actor in the Apify store.
3. Configure the actor with your search terms and location.
4. Run the actor and download results as CSV or JSON.

### API Configuration

For automated pipelines, use the Apify API:

- **Actor name:** `compass/crawler-google-places`
- **API endpoint:** `https://api.apify.com/v2/acts/compass~crawler-google-places/runs`
- **Authentication:** API token from Apify settings
- **Input format:** JSON with `searchStringsArray` and `locationQuery` fields
- **Output:** JSON array of business listings with name, address, phone, website, reviews, rating

### Free Tier

Apify's free tier includes $5/month in platform credits, enough for approximately 200-500 Google Maps results depending on search complexity.

## Cost Expectations

| Volume | Monthly Cost | Notes |
|--------|-------------|-------|
| 50 leads/month | $1-3 | ~100 raw results, 50% filter pass rate |
| 200 leads/month | $5-10 | ~400 raw results, typical for single-city pipeline |
| 500 leads/month | $15-25 | ~1000 raw results, multi-city or multi-niche |

All costs are Apify platform credits only. No other infrastructure needed.

## Integration with Outreach

After filtering and scoring:

1. Export the filtered list as CSV.
2. For each viable lead, create a lead file in `context/outreach/` using the outreach template.
3. Track outreach progress with `/agency-ops:outreach`.
4. Move leads that respond positively into `context/pipeline/` via `/agency-ops:pipeline`.

## Niche-Specific Configuration

Use these variables to customize for your {{target_niche}}:

- **{{target_niche}}:** Your primary vertical (dental, med spa, roofing, etc.)
- **{{target_city}}:** Primary city or metro area for prospecting
- **{{min_reviews}}:** Minimum Google review count (default: 10)
- **{{max_reviews}}:** Maximum Google review count (default: 500)

---

*This reference covers LEADGEN-01 (Rankwell V2 pipeline reference) and LEADGEN-04 (Apify documentation with setup, API configuration, and cost expectations). It is available as an optional strategy -- not the default recommendation.*
