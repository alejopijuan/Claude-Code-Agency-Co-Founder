---
name: "Sunrise Dental"
industry: "dental"
status: active
monthly_value: 1500
start_date: "2026-02-10"
meeting_cadence: biweekly
last_updated: "2026-03-25"
staleness_threshold_days: 14
---

> **This is a fictional example client for reference.** It shows what a well-maintained client file looks like. Use `/agency-ops:new-client` to create your own.

# Sunrise Dental

> **This is a fictional example client for reference.** It shows what a well-maintained client file looks like after a few weeks of active work. Use it as a model when creating your own client files with `/agency-ops:new-client`.

## Project Scope

- **Project:** Speed-to-lead voice agent for new patient inquiries
- **Voice AI Platform:** Retell
- **CRM:** Dentrix (no open API — using Zapier webhook as bridge)
- **Use Case:** When a lead fills out the "Request Appointment" form on their website, the AI calls them within 60 seconds, qualifies them (insurance, preferred location, urgency), and books directly into the next available slot
- **Success Metric:** Increase form-to-appointment conversion from ~15% to 40%+
- **Monthly Fee:** $1,500/month (includes 500 minutes of call time)

## Key Contacts

- Dr. Sarah Chen (Owner, 2 locations) — sarah@sunrisedental.com — Decision maker, wants ROI data
- Mike Rodriguez (Office Manager, Downtown location) — mike@sunrisedental.com — Day-to-day ops, manages the front desk team
- Lisa Park (Marketing Coordinator) — lisa@sunrisedental.com — Runs the Google Ads that generate the lead forms

## Communication Preferences

- **Channel:** Slack (#sunrise-dental channel in our workspace)
- **Frequency:** Biweekly check-ins, Tuesdays at 2pm ET
- **Style:** Dr. Chen prefers concise updates with hard numbers (calls made, appointments booked, conversion rate). Mike likes detailed walkthroughs of call recordings. Lisa wants to know which ad campaigns are producing the best leads.
- **Escalation:** Call Mike directly for urgent issues (agent down, wrong booking). Text Dr. Chen only for billing or contract questions.

## Meeting Cadence

- Biweekly check-ins: Tuesdays at 2pm ET (30 min, Zoom)
- Monthly review: First Tuesday of the month, extended to 45 min, includes Lisa
- Ad-hoc: Mike can request a quick 15-min call anytime via Slack

## Active Projects

- [x] Speed-to-lead voice agent v1 — LIVE since 2026-03-10
- [ ] After-hours inbound receptionist — scoped, not started (waiting for S2L proof)
- [ ] Database reactivation campaign — discussed, not scoped (Dr. Chen interested but wants S2L results first)

## Commitments Log

| Date | Commitment | Owner | Status | Due |
| ---- | ---------- | ----- | ------ | --- |
| 2026-02-10 | Deliver voice agent prototype for internal testing | Us | Done | 2026-02-21 |
| 2026-02-21 | Provide Dentrix webhook credentials for Zapier bridge | Sunrise | Done | 2026-02-28 |
| 2026-02-28 | Configure Zapier bridge: form submission → Retell trigger → Dentrix booking | Us | Done | 2026-03-07 |
| 2026-03-07 | Go live with speed-to-lead agent on Downtown location | Us | Done | 2026-03-10 |
| 2026-03-10 | Share first week call recordings for quality review | Us | Done | 2026-03-17 |
| 2026-03-17 | Provide 2-week conversion data (forms submitted vs appointments booked) | Lisa | In Progress | 2026-03-25 |
| 2026-03-20 | Fix agent greeting — patients confused by "Sunrise Dental Downtown" when calling Midtown number | Us | Done | 2026-03-22 |
| 2026-03-25 | Prepare ROI report for Dr. Chen: before/after conversion rates, cost per appointment | Us | Pending | 2026-04-01 |
| 2026-03-25 | Scope after-hours inbound receptionist — draft proposal with pricing tiers | Us | Pending | 2026-04-08 |

## Meeting Notes

### 2026-03-25 — Biweekly Check-in

**Attendees:** Mike, Lisa (Dr. Chen joined for last 10 min)
**Duration:** 35 min

- Agent handled 47 calls in first 2 weeks. 31 resulted in booked appointments (66% conversion!)
- Mike flagged 3 calls where agent booked patients at wrong location (Downtown vs Midtown). Root cause: agent wasn't asking which location. **Fixed same day** — added location qualifier to call flow.
- Lisa shared that Google Ads form submissions are up 20% month-over-month. Agent is handling the volume well.
- Dr. Chen joined and asked about after-hours coverage. She's losing 8-10 calls per week after 6pm. Interested in a quote for after-hours inbound receptionist.
- **Action:** Prepare ROI report + after-hours proposal for April 1 monthly review.

### 2026-03-11 — Biweekly Check-in

**Attendees:** Mike
**Duration:** 20 min

- First day live. 4 calls made, 3 appointments booked, 1 no-answer (left voicemail via agent).
- Mike was impressed by call quality. Shared recording of one call where patient said "oh wow, that was fast."
- Discussed monitoring plan: review all call recordings for first week, then switch to spot-checks.
- Mike mentioned their database has ~2,000 patients who haven't visited in 12+ months. Potential for DBR campaign.
- **Action:** Share all week-1 recordings with Mike by Monday.

## Notes

- Dr. Chen wants hard ROI data before expanding scope. Get at least 2 weeks of production data before proposing Phase 2 (after-hours inbound).
- The Dentrix API is locked down — no direct integration possible. The Zapier webhook bridge works but adds ~3 seconds latency to booking confirmation. Acceptable for now.
- Office hours: Mon-Fri 8am-6pm, Sat 9am-2pm, closed Sunday. After-hours agent should cover Mon-Sat evenings + Sunday.
- Lisa manages a $3,000/month Google Ads budget. If our S2L agent proves ROI, she wants to increase ad spend and route all leads through the agent.
- Mike is our champion internally. Keep him happy with detailed walkthroughs.
- **Testimonial opportunity:** Dr. Chen mentioned she'd be willing to do a video testimonial if the 30-day numbers look good. Target: ask by April 8.

## Last Updated

2026-03-25
