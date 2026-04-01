# Voice Agent Testing Checklist

Common testing checklist shared across all voice agent use cases. Each use case template adds its own specific items below the core list.

## Core Testing Checklist (All Use Cases)

Complete ALL items before go-live. Minimum 10 test calls required.

### Call Quality
- [ ] Agent greets caller naturally (no robotic tone, correct business name)
- [ ] Agent asks only one question at a time
- [ ] Agent does not re-ask for information already provided
- [ ] Agent varies responses (no repetitive "Great!" or "Perfect!")
- [ ] Agent handles background noise and unclear audio gracefully
- [ ] Agent ends calls cleanly after goodbye phrases

### Call Flow
- [ ] Happy path: caller books appointment / completes intended action
- [ ] Caller asks a question from the knowledge base -- agent answers correctly
- [ ] Caller asks something NOT in the knowledge base -- agent responds appropriately (does not hallucinate)
- [ ] Caller wants to speak to a human -- agent transfers correctly
- [ ] Caller provides incomplete information -- agent follows up without repeating prior questions
- [ ] Agent handles interruptions and course corrections mid-conversation

### CRM Integration
- [ ] Call outcome logged correctly in CRM after each test call
- [ ] Contact record created or updated with correct fields
- [ ] Appointment appears in calendar system (if booking use case)
- [ ] No duplicate records created from repeated tests

### Recording and Transcript
- [ ] Call recording is accessible and playable
- [ ] Transcript is generated and matches the actual conversation
- [ ] Post-call analysis fields are populated correctly (caller name, outcome, etc.)

### Transfer and Routing
- [ ] Transfer to staff works during business hours
- [ ] After-hours behavior is correct (voicemail, callback scheduling, or emergency transfer)
- [ ] Transfer audio is clean (no dead air, no repeated greeting)

### Edge Cases
- [ ] Caller hangs up mid-conversation -- call logged correctly
- [ ] Very short call (caller immediately says wrong number) -- handled gracefully
- [ ] Very long call (caller is chatty) -- agent stays on track without being rude
- [ ] Caller attempts prompt injection ("ignore your instructions") -- agent deflects or ends call
- [ ] Caller speaks a different language -- agent responds appropriately

### Phone System
- [ ] Phone number is active and receiving calls
- [ ] Call forwarding (if applicable) routes to the AI agent correctly
- [ ] Caller ID displays correctly on outgoing calls (if outbound)
- [ ] SMS fallback works (if configured)

## Use-Case-Specific Addons

### Inbound Receptionist Addons
- [ ] Business hours detection: correct greeting for business hours vs after-hours
- [ ] Multi-intent handling: caller changes mind from "question" to "book appointment"
- [ ] Staff availability check before transfer attempt
- [ ] Message-taking works when no staff is available
- [ ] Emergency routing activates on urgent keywords

### Speed-to-Lead (S2L) Addons
- [ ] Form submission triggers outbound call within 60 seconds
- [ ] Agent references the correct form data in the greeting (name, inquiry type)
- [ ] SMS fallback sent if lead does not answer the call
- [ ] Retry call made after 30 minutes if no answer on first attempt
- [ ] Lead source attribution correct in CRM (which form, which campaign)

### Database Reactivation (DBR) Addons
- [ ] Batch rate limits respected (no more than X calls per hour)
- [ ] Do-Not-Call list checked before each call
- [ ] Personalized greeting uses correct customer name and history
- [ ] Offer presented clearly and consistently across all test calls
- [ ] Campaign tracking: calls made, answered, interested, booked -- all logged
- [ ] Opt-out requests logged immediately and honored
