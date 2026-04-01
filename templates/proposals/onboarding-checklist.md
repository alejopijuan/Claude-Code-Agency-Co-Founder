# Client Onboarding Checklist -- {{client_name}}

**Project:** {{project_description}}
**Voice AI Platform:** {{voice_platform}}
**CRM:** {{crm_system}}
**Start Date:** {{start_date}}
**Onboarding Lead:** {{agency_contact_name}}

---

## Pre-Kickoff

Complete these items before the first kickoff meeting with {{client_name}}.

- [ ] **CRM credentials received** -- Login URL, username/password or API keys for {{crm_system}}
- [ ] **CRM access verified** -- Confirmed we can log in and access relevant modules (appointments, contacts, leads)
- [ ] **Phone number(s) identified** -- Existing business line to forward from, or new number to provision
  - Number: {{phone_number}}
  - Type: {{phone_type}} (existing line / new number / toll-free)
- [ ] **Knowledge base documents collected** -- FAQs, common questions, service descriptions, pricing info
  - [ ] FAQ document
  - [ ] Service/product list
  - [ ] Pricing information (if agent needs to quote)
  - [ ] Location details (address, hours, directions)
- [ ] **Business hours confirmed**
  - Monday-Friday: {{weekday_hours}}
  - Saturday: {{saturday_hours}}
  - Sunday: {{sunday_hours}}
  - Holidays: {{holiday_schedule}}
- [ ] **Transfer rules documented** -- Who gets transferred calls and when
  - [ ] During business hours: transfer to {{transfer_contact_business_hours}}
  - [ ] After hours: {{after_hours_action}} (voicemail / emergency number / schedule callback)
  - [ ] Emergency/urgent: call {{emergency_contact}} at {{emergency_number}}
  - [ ] Specific departments: {{department_routing}}
- [ ] **Greeting script preferences discussed**
  - Preferred greeting: "{{greeting_script}}"
  - Tone: {{greeting_tone}} (professional / friendly / casual)
  - Key phrases to include: {{key_phrases}}
  - Phrases to avoid: {{avoid_phrases}}
- [ ] **Key contacts identified**
  - Decision maker: {{decision_maker_name}} -- {{decision_maker_email}}
  - Day-to-day contact: {{daily_contact_name}} -- {{daily_contact_email}}
  - Technical contact (if different): {{tech_contact_name}} -- {{tech_contact_email}}
- [ ] **Meeting cadence agreed** -- {{meeting_cadence}} check-ins, {{meeting_day}} at {{meeting_time}}
- [ ] **Communication channel set up** -- {{communication_channel}} (Slack / email / phone)

---

## Technical Setup

Complete these items to get the voice agent ready for testing.

- [ ] **Voice AI platform account created** -- {{voice_platform}} account set up for this project
- [ ] **Phone number provisioned** -- Number active and verified on {{voice_platform}}
  - Number: {{provisioned_number}}
  - Forwarding configured from: {{forwarding_from}}
- [ ] **Voice agent created** -- Base agent configured on {{voice_platform}}
  - [ ] Agent name set
  - [ ] Voice selected (language, accent, gender)
  - [ ] Call flow built per system design document
- [ ] **Knowledge base uploaded** -- FAQs, scripts, and business info loaded into agent
- [ ] **CRM webhook configured** -- {{crm_system}} connected for:
  - [ ] Appointment booking
  - [ ] Lead/contact creation
  - [ ] Call outcome logging
  - [ ] Call recording attachment (if supported)
- [ ] **Call recording storage set up** -- Recordings stored and accessible for review
  - Storage: {{recording_storage}} (platform default / cloud storage / CRM)
- [ ] **Test calls completed (internal)** -- Minimum 20 test calls covering:
  - [ ] Standard appointment booking flow
  - [ ] FAQ responses (5+ common questions)
  - [ ] Transfer to human (during business hours)
  - [ ] After-hours handling
  - [ ] Edge cases (caller hangs up, unclear request, non-English speaker)
  - [ ] CRM data verified after each test call
- [ ] **Test call recordings reviewed** -- Quality check on:
  - [ ] Greeting sounds natural
  - [ ] Responses are accurate
  - [ ] Transfers work correctly
  - [ ] CRM entries are correct
  - [ ] No awkward pauses or misunderstandings

---

## Go-Live

Complete these items to launch the voice agent in production.

- [ ] **Client approval received** -- {{client_contact_name}} has reviewed test recordings and approved:
  - [ ] Call flow and conversation quality
  - [ ] Greeting script
  - [ ] CRM integration accuracy
  - [ ] Transfer behavior
- [ ] **Staff training completed** -- {{client_name}} team trained on:
  - [ ] How AI-handled calls appear in {{crm_system}}
  - [ ] How to identify AI vs. human calls
  - [ ] How to flag issues or request changes
  - [ ] Who to contact for urgent problems ({{agency_contact_name}})
- [ ] **Monitoring plan established**
  - Week 1: Daily review of all call recordings
  - Weeks 2-4: Review flagged calls + weekly performance report
  - Month 2+: Weekly spot-checks + monthly performance report
- [ ] **Emergency rollback plan documented**
  - Rollback method: {{rollback_method}} (disable forwarding / revert to previous number / manual override)
  - Rollback contact: {{rollback_contact}}
  - Rollback trigger: {{rollback_trigger}} (e.g., 3+ failed calls in 1 hour)
- [ ] **Go-live activated** -- Voice agent live on production number
  - Go-live date: {{go_live_date}}
  - Go-live time: {{go_live_time}}

---

## Post-Launch (Week 1)

Complete these items during the first week after go-live.

- [ ] **All call recordings reviewed** -- Listen to every call from Days 1-3, then spot-check Days 4-7
  - Total calls Day 1: ___
  - Issues found: ___
  - Fixes applied: ___
- [ ] **Call flow issues identified and fixed** -- Document any problems and resolutions:
  - Issue 1: ___  |  Fix: ___  |  Date fixed: ___
  - Issue 2: ___  |  Fix: ___  |  Date fixed: ___
- [ ] **CRM data accuracy verified** -- Spot-check that appointments, leads, and call outcomes match call recordings
- [ ] **Week 1 performance report shared with client** -- Include:
  - [ ] Total calls handled
  - [ ] Calls completed successfully (appointments booked, questions answered)
  - [ ] Calls transferred to human
  - [ ] Calls with issues (and resolution status)
  - [ ] Conversion rate (if applicable)
  - [ ] Average call duration
- [ ] **Recurring check-in meetings scheduled** -- {{meeting_cadence}} meetings set up with {{client_contact_name}}
  - First check-in: {{first_checkin_date}}
  - Recurring: {{meeting_day}} at {{meeting_time}}
- [ ] **Client feedback collected** -- Ask {{client_contact_name}}:
  - Are they satisfied with call quality?
  - Any calls that didn't go well?
  - Any changes to greeting, FAQ responses, or transfer rules?
  - Comfortable with current monitoring frequency?

---

## Notes

{{onboarding_notes}}

---

**Checklist completed by:** {{agency_contact_name}}
**Date completed:** {{completion_date}}
