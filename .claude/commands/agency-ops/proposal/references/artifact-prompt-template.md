# Claude Artifact Prompt Template -- Interactive Proposal

Use this template to generate a Claude artifact prompt. Fill all `{{variable}}` placeholders with actual values from the client and agency context, then output the completed prompt for the user to copy into Claude's artifact UI.

---

## Prompt to Copy

```
Create a React artifact for an interactive proposal presentation with the following details:

**Agency:** {{agency_name}}
**Client:** {{client_name}}
**Industry:** {{client_industry}}
**Date:** {{date}}

---

### Design Requirements

Build a clean, professional single-page proposal with these interactive features:
- A tabbed or accordion layout so the client can expand/collapse sections
- A pricing toggle that switches between the three tiers (Starter, Growth, Scale)
- A sticky header with agency and client names
- Professional color scheme (use navy/dark blue primary with white/light gray accents)
- Mobile-responsive layout

---

### Content Sections

**1. Header**
- Agency logo area (text-based: "{{agency_name}}")
- "Proposal for {{client_name}}"
- Date: {{date}}
- Prepared by: {{agency_name}}

**2. Executive Summary**
{{project_description}}

The current challenge: {{client_pain_points}}

**3. Proposed Solution**
{{proposed_solution}}

Key approach:
- Voice AI platform: {{voice_platform}}
- Integration with: {{crm_system}}
- Use case: {{use_case_type}}
- Expected implementation timeline: {{timeline}}

**4. Deliverables**
Create an itemized list with checkmarks:
{{deliverables_list}}

Each deliverable should show:
- Description
- Estimated completion (week number)
- Dependencies (if any)

**5. Implementation Timeline**
Show a visual timeline or Gantt-style chart with these phases:

- **Phase 1: Discovery and Design** ({{phase1_duration}})
  - Call flow design
  - Integration mapping
  - CRM setup planning

- **Phase 2: Build and Test** ({{phase2_duration}})
  - Voice agent configuration
  - Integration testing
  - Call recording review
  - Internal test calls

- **Phase 3: Launch and Optimize** ({{phase3_duration}})
  - Go-live
  - Daily monitoring (week 1)
  - Weekly optimization
  - Performance reporting

**6. Pricing Tiers**
Create an interactive pricing toggle with three tiers:

**Starter -- {{starter_price}}/month**
- {{starter_includes}}
- Single use case
- Email support
- Monthly performance report

**Growth -- {{growth_price}}/month**
- {{growth_includes}}
- Up to 3 use cases
- Priority support
- Weekly performance reports
- CRM integration included

**Scale -- {{scale_price}}/month**
- {{scale_includes}}
- Unlimited use cases
- Dedicated support
- Real-time dashboard
- Ongoing optimization
- Quarterly business reviews

Highlight the recommended tier with a "Recommended" badge.

**7. ROI Projections**
Display these metrics in a visual card layout:

- **Current state:**
  - {{current_call_volume}} calls/month
  - {{current_conversion_rate}}% conversion rate
  - {{current_response_time}} average response time
  - {{current_cost_per_call}} cost per handled call

- **Projected with voice AI:**
  - {{projected_call_volume}} calls/month capacity
  - {{projected_conversion_rate}}% projected conversion rate
  - {{projected_response_time}} response time
  - {{projected_cost_per_call}} cost per handled call
  - **{{projected_monthly_savings}} estimated monthly savings**

- **ROI timeline:** {{roi_timeline}}

**8. Why {{agency_name}}**
{{agency_differentiators}}

**9. Next Steps**
1. Review this proposal
2. Select a pricing tier
3. Schedule a follow-up call to discuss details
4. Sign the scope of work
5. Kick off Phase 1

Include a prominent CTA button: "Schedule Follow-Up Call"

---

### Technical Notes for the Artifact
- Use Tailwind CSS classes for styling
- Make all sections collapsible/expandable
- Pricing tier cards should highlight on hover
- ROI section should use large, bold numbers
- Add smooth scroll between sections
- Keep total code under 500 lines
```

---

## Variable Reference

| Variable | Source | Description |
|----------|--------|-------------|
| `{{agency_name}}` | agency.md | Agency name |
| `{{client_name}}` | client file | Client/company name |
| `{{client_industry}}` | client file | Client's industry |
| `{{date}}` | current date | Proposal date |
| `{{project_description}}` | client file + user input | What the project is |
| `{{client_pain_points}}` | user input | Current challenges |
| `{{proposed_solution}}` | user input | Voice AI approach |
| `{{voice_platform}}` | agency.md | Retell/Vapi/ElevenLabs |
| `{{crm_system}}` | client file | Client's CRM |
| `{{use_case_type}}` | client file | Inbound/S2L/DBR |
| `{{timeline}}` | user input | Total project duration |
| `{{deliverables_list}}` | user input | Itemized deliverables |
| `{{phase1_duration}}` | user input | Discovery phase length |
| `{{phase2_duration}}` | user input | Build phase length |
| `{{phase3_duration}}` | user input | Launch phase length |
| `{{starter_price}}` | agency.md / user input | Starter tier price |
| `{{starter_includes}}` | user input | What starter includes |
| `{{growth_price}}` | agency.md / user input | Growth tier price |
| `{{growth_includes}}` | user input | What growth includes |
| `{{scale_price}}` | agency.md / user input | Scale tier price |
| `{{scale_includes}}` | user input | What scale includes |
| `{{current_call_volume}}` | user input | Current monthly calls |
| `{{current_conversion_rate}}` | user input | Current conversion % |
| `{{current_response_time}}` | user input | Current avg response |
| `{{current_cost_per_call}}` | user input | Current cost/call |
| `{{projected_call_volume}}` | calculated | Projected capacity |
| `{{projected_conversion_rate}}` | calculated | Projected conversion % |
| `{{projected_response_time}}` | calculated | Projected response |
| `{{projected_cost_per_call}}` | calculated | Projected cost/call |
| `{{projected_monthly_savings}}` | calculated | Monthly savings |
| `{{roi_timeline}}` | user input | Months to ROI |
| `{{agency_differentiators}}` | agency.md / user input | Why choose this agency |
