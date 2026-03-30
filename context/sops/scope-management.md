# Scope Management SOP

How to handle scope creep in voice AI agency projects without losing the client. This is the most common source of project delays, margin erosion, and client friction -- get it right and you protect both the relationship and your profitability.

## 1. Recognizing Scope Creep

Scope creep happens when the client asks for work that was not included in the signed SOW. In voice AI projects, it shows up in predictable ways.

### Common Scope Creep Requests

| What They Ask | Why It Is Scope Creep | What You Should Do |
|---|---|---|
| "Can the agent also handle billing questions?" | Adds a new intent category, new knowledge base, new CRM actions | Scope as Phase 2 |
| "Can you add a chatbot to our website too?" | Entirely different product (text vs voice) | Separate project/SOW |
| "Can the agent speak Spanish too?" | Bilingual requires new voice model, new scripts, new testing | Add-on pricing or Phase 2 |
| "Can you also manage our Google Ads?" | Outside your service scope entirely | Refer to a partner or decline |
| "Can you build us a CRM dashboard?" | Custom development, not voice AI | Separate project or refer out |
| "Can the agent call our entire database this week?" | DBR campaign not in current scope, requires new call flow, compliance review | Scope as new project |
| "Can you make the agent sound like [specific person]?" | Custom voice cloning, licensing, additional platform cost | Add-on pricing |

### Red Flags to Watch For

- Requests that require integrations not in the original scope.
- Requests that require a new call flow or significantly modifying an existing one.
- Requests that come from someone other than the person who signed the contract.
- The phrase "while you're at it" or "this should be easy, right?"
- Requests that blur the line between your service and their internal operations.

## 2. The "Not Right Now" Framework

You never want to say "no" to a client. You want to say "not right now" -- and here is exactly how.

### The 3-Step Response

**Step 1: Acknowledge the value.**
"That's a great idea. I can see why you'd want that."

**Step 2: Explain the impact.**
"Adding that would require [specific work], which would extend the timeline by [X weeks] and add [Y] to the project cost."

**Step 3: Offer the alternative.**
"Here's what I recommend: let's nail the current scope first and get your [current use case] running smoothly. Then we can scope [their request] as Phase 2 with its own timeline and pricing."

### Example Scripts

**Client says:** "Can the agent also handle our appointment reminders? It already has the booking data."

**You say:** "Great idea -- appointment reminders would be a natural extension. Right now, the agent is set up for inbound call handling, and adding outbound reminders would need a separate call flow, scheduling logic, and opt-in compliance work. Let's get the inbound agent stable for 2-3 weeks, then I'll put together a proposal for an outbound reminder module as Phase 2. That way we can use the real booking data to design the reminder timing perfectly."

**Client says:** "Can you just quickly add a text message follow-up after each call?"

**You say:** "SMS follow-up is a great touch -- it really improves the patient experience. It does require an SMS provider integration (like Twilio), a message template, opt-in tracking for compliance, and testing. I can scope that as an add-on. Want me to put together pricing for it? We could have it live within a week of approval."

**Client says:** "My partner wants the agent to also answer our email inquiries."

**You say:** "I understand -- having one system handle all communication channels makes sense long-term. Email handling is a different type of automation from voice AI though. It would be a separate project with its own scope and timeline. I'd be happy to scope that out for you, or I can refer you to someone who specializes in email automation if you'd prefer."

## 3. Phased Delivery

Structure every project so that scope creep becomes upsell opportunity.

### Phase Structure

**Phase 1: Core Use Case (Current SOW)**
- Single use case: inbound receptionist, speed-to-lead, or database reactivation.
- Core integrations only (CRM, calendar).
- Prove the concept. Get measurable results.
- Timeline: 2-4 weeks to go-live.

**Phase 2: Enhancement (Separate SOW)**
- Additional features on the same use case: bilingual support, SMS follow-up, advanced routing.
- Or second use case: add after-hours coverage to a S2L project.
- Build on proven foundation.
- Timeline: 1-2 weeks per enhancement.

**Phase 3: Expansion (Separate SOW)**
- New use cases: DBR campaign, outbound reminders, multi-location routing.
- Advanced integrations: payment processing, EMR/EHR systems, custom APIs.
- Strategic planning for their full voice AI roadmap.
- Timeline: varies by complexity.

### Why This Works

- Each phase has its own SOW, its own timeline, and its own payment.
- The client sees a clear progression and does not feel locked out of future features.
- You get to bill for each phase separately, protecting your margins.
- Results from Phase 1 justify Phase 2 investment (your best salesperson is a working agent).
- If the client churns after Phase 1, you are not stuck with unbilled Phase 2 work.

## 4. Change Request Process

When a client requests something outside the current scope and you both agree it should be done now (not deferred), follow this process:

1. **Document the request.** Write down exactly what they are asking for, in their words. Read it back to them: "Just to make sure I have this right -- you want the agent to [specific request]. Is that correct?"
2. **Estimate effort and cost.** Take at least 24 hours before providing an estimate. Do not guess on the spot. Consider:
   - Platform time (Retell/Vapi/ElevenLabs configuration)
   - Integration work (n8n workflows, API connections)
   - Testing (new test cases, edge cases)
   - Impact on existing call flow (does changing this break something else?)
3. **Present as a formal change order.** Send a brief written document (email is fine) with:
   - Description of the requested change
   - Impact on current timeline (pushes go-live by X days)
   - Additional cost (one-time or increase to monthly retainer)
   - What happens to in-progress work while the change is implemented
4. **Get written approval.** Do not start work until you have written confirmation (email reply saying "approved" is sufficient). This protects both you and the client.
5. **Update the SOW.** Add an amendment referencing the change order. Update the client file commitments log with the new work.

## 5. Prevention Tips

The best scope management happens before the project starts.

1. **Write clear SOWs with explicit exclusions.** Your SOW should have a section called "What's Not Included" that lists common requests you know are out of scope. For example:
   - "This project covers inbound call handling only. Outbound calling, SMS messaging, email automation, chatbots, and website development are not included."
2. **Monthly scope check-in.** During your monthly review meeting, explicitly ask: "Is there anything you'd like the agent to do that it currently doesn't?" This gives you a controlled channel for new requests instead of ad-hoc pings.
3. **Reference your service agreement.** The service agreement template at `templates/proposals/service-agreement.md` includes a scope boundaries section. When scope creep arises, you can refer back to it: "Let me check our agreement... right, that falls outside the current scope. Let me put together a change order for you."
4. **Track scope creep patterns.** If the same type of request comes up across multiple clients, consider adding it to your standard offering or creating a standard add-on package.
5. **Educate during onboarding.** During the kickoff meeting, set expectations: "Over the next few weeks, you'll probably think of additional things you'd like the agent to do. That's great -- write them down and we'll review them together at our monthly check-in. This way we can prioritize and scope them properly rather than trying to squeeze them into the current build."

---

*Cross-references: `templates/proposals/scope-of-work.md`, `templates/proposals/service-agreement.md`, `context/sops/client-onboarding.md`*
