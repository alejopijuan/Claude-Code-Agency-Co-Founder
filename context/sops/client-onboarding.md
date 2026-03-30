# Client Onboarding SOP

Step-by-step process for bringing a new voice AI client from first contact to go-live. Follow this checklist every time you sign a new client to ensure nothing falls through the cracks.

## 1. Pre-Discovery Call

Before you get on the phone with a prospect, do your homework.

1. Research their business online. Visit their website, check Google reviews, look at their social media presence.
2. Identify their likely pain points. For most local businesses, these fall into three buckets:
   - **Missed calls** -- receptionist overwhelmed, calls going to voicemail, losing potential customers.
   - **Slow lead response** -- web form submissions sitting for hours or days before follow-up.
   - **After-hours coverage** -- no one answering after 5pm, weekends, or holidays.
3. Note their current tech stack. Do they mention a CRM on their website? Do they use online booking? What phone system are they on?
4. Check if they already use any automation or AI tools. Look for chatbots on their site, automated booking widgets, or IVR systems.
5. Prepare 2-3 talking points specific to their industry. For example, if they are a dental practice, mention that the average dental office misses 30% of incoming calls.

## 2. Discovery Call Checklist

Run `/agency-ops:meeting-prep` before the call to generate a structured agenda. During the call, gather answers to these questions:

### Must-Know Questions

1. **Call volume:** "How many inbound calls does your office handle per day/week?"
2. **Missed call rate:** "Do you know roughly how many calls go to voicemail or get abandoned?"
3. **After-hours handling:** "What happens when someone calls after business hours? Do you have an answering service?"
4. **Lead response time:** "When a new lead fills out a form on your website, how quickly does someone follow up?"
5. **CRM system:** "What system do you use to track patients/customers/leads?" (Dentrix, ServiceTitan, HubSpot, spreadsheet, etc.)
6. **Phone system:** "Are you on a VoIP system or traditional landlines?" (This affects call forwarding and integration options.)
7. **Decision-making process:** "Besides yourself, who else would need to approve this?"
8. **Budget range:** "Have you set aside a budget for this kind of solution, or are you exploring what's possible?"
9. **Timeline:** "Is there a specific date or event driving the urgency?" (New location opening, busy season, staff shortage, etc.)

### Nice-to-Know Questions

10. **Team size:** "How many people currently handle phones?"
11. **Peak hours:** "When are your busiest times for calls?"
12. **Existing automation:** "Do you use any automation tools today?" (Zapier, Make, n8n, etc.)
13. **Pain stories:** "Can you walk me through what happened the last time you missed an important call?"

## 3. Scope Definition

After the discovery call, map out what you are building.

1. **Identify the primary use case.** Based on discovery, select one:
   - **Inbound Receptionist** -- best for high call volume, after-hours needs, receptionist bottlenecks.
   - **Speed-to-Lead (S2L)** -- best for businesses with web forms and slow lead response.
   - **Database Reactivation (DBR)** -- best for businesses with large dormant customer lists.
2. **Map the call flow.** Write out what happens step by step:
   - How does the call/trigger start? (Inbound ring, form submission webhook, scheduled outbound batch)
   - What does the AI agent say first?
   - What qualifying questions does it ask?
   - What actions does it take? (Book appointment, transfer to staff, send info, log in CRM)
   - What happens if the caller needs a human?
3. **Define integrations.** List every system the agent needs to connect to:
   - CRM (e.g., Dentrix via Zapier bridge, ServiceTitan API, HubSpot webhook)
   - Calendar/booking system
   - Phone system (call forwarding, SIP trunking)
   - Payment processor (if applicable)
4. **Set success metrics.** Pick 1-2 measurable outcomes:
   - Form-to-appointment conversion rate (S2L)
   - Missed call reduction percentage (Inbound)
   - Re-engagement response rate (DBR)
   - Average response time improvement

## 4. Pricing Proposal

1. Run `/agency-ops:proposal` to generate a customized proposal based on the client file and discovery notes.
2. Reference the SOW template at `templates/proposals/scope-of-work.md` for structure.
3. Present 3 pricing tiers to give the prospect options:
   - **Starter:** Core use case only, limited minutes, basic integrations.
   - **Growth:** Core use case + additional features (e.g., bilingual, SMS follow-up), more minutes.
   - **Scale:** Multiple use cases, unlimited minutes, priority support, custom integrations.
4. Include a one-time setup fee covering: platform configuration, call flow design, integration setup, testing, and go-live support.
5. Include a monthly retainer covering: platform costs, minutes, monitoring, monthly optimization, and support.

## 5. Contract Signing

1. Use the service agreement template at `templates/proposals/service-agreement.md`.
2. Walk the client through key terms:
   - **Scope section:** Explicitly state what is included AND what is excluded. This prevents scope creep later.
   - **Payment terms:** Setup fee due before work begins, monthly retainer billed on the 1st.
   - **Timeline:** Expected go-live date with milestones.
   - **Termination:** 30-day notice, no long-term lock-in (this builds trust).
3. Get the agreement signed before you start any configuration work. No handshake deals.
4. Send a copy of the signed agreement to both parties. Save it in your records.

## 6. Kickoff Meeting

1. Schedule a 45-60 minute kickoff meeting within 3 days of signing.
2. Review the scope, timeline, and deliverables together. Make sure everyone is aligned.
3. Collect all onboarding items using the checklist at `templates/proposals/onboarding-checklist.md`:
   - **CRM credentials** or API access (read/write permissions for the agent)
   - **Phone numbers** to configure (which number(s) should the agent answer or call from?)
   - **Knowledge base content** (FAQs, services list, pricing, office hours, locations, staff names)
   - **Greeting preferences** (how should the AI introduce itself? "Hi, this is Sarah from Sunrise Dental" vs "Thank you for calling Sunrise Dental")
   - **Business hours** (when is the agent active? 24/7 or business hours only?)
   - **Transfer rules** (when should the agent transfer to a human? What number?)
   - **Booking rules** (appointment types, durations, buffer times, provider preferences)
4. Set expectations for the build timeline: typically 5-10 business days from receiving all onboarding items.
5. Run `/agency-ops:new-client` to create the client context file if you have not already.

## 7. Tool Setup

1. **Provision the voice AI platform account.** Set up the client's project in Retell, Vapi, or ElevenLabs (whichever you use).
2. **Configure phone numbers.** Port or forward the client's number, or provision a new number.
3. **Build the call flow.** Implement the call flow you mapped in Step 3. Include:
   - Greeting and introduction
   - Qualifying questions
   - Actions (booking, transfer, info delivery)
   - Fallback handling (confused caller, edge cases, request for human)
   - Goodbye and confirmation
4. **Set up CRM integration.** Connect the agent to the client's CRM so call outcomes are logged automatically. Common setups:
   - Direct API integration (HubSpot, GoHighLevel)
   - Webhook bridge via Zapier or n8n (Dentrix, ServiceTitan, proprietary systems)
5. **Configure call recording.** Enable recording for quality review and compliance. Confirm with the client that recording is acceptable in their jurisdiction.
6. **Run test calls.** Make at least 10 test calls covering different scenarios:
   - Happy path (caller books an appointment successfully)
   - Edge case (caller asks something unexpected)
   - Transfer request (caller wants to speak to a human)
   - After-hours behavior (if applicable)
   - Error handling (CRM is down, calendar is full)

## 8. Go-Live

1. **Get client approval.** Share 2-3 test call recordings with the client. Walk them through how the AI handled each scenario. Get explicit approval to go live.
2. **Train their staff.** Show the team how AI-handled calls appear in their CRM, how to identify AI vs human calls, and who to contact if something seems wrong.
3. **Flip the switch.** Route live calls to the AI agent. Start with business hours only if the client is nervous, then expand to after-hours.
4. **Monitor daily for Week 1.** Review every call recording for the first 5 business days. Fix any issues immediately. Share a daily 2-line update with the client: calls handled, appointments booked.
5. **Schedule recurring check-ins.** Set up the agreed meeting cadence (weekly or biweekly). Use `/agency-ops:meeting-prep` before each check-in.
6. **30-day review.** At the one-month mark, compile performance data and present an ROI summary. This is also the right time to discuss Phase 2 (additional use cases) and to ask for a testimonial (see the Testimonial Collection SOP).

---

*Cross-references: `/agency-ops:meeting-prep`, `/agency-ops:proposal`, `/agency-ops:new-client`, `/agency-ops:follow-up`, `templates/proposals/onboarding-checklist.md`, `templates/proposals/scope-of-work.md`, `templates/proposals/service-agreement.md`*
