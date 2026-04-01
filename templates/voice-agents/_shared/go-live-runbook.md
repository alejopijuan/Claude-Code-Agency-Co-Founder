# Voice Agent Go-Live Runbook

Shared go-live structure for all voice agent deployments. Each use case template references this and adds use-case-specific monitoring items.

## Pre-Launch (Day Before)

- [ ] All testing checklist items passed (see testing-checklist.md)
- [ ] Client has reviewed and approved 3+ test call recordings
- [ ] CRM integration verified with client's actual CRM instance (not test)
- [ ] Phone number verified and active
- [ ] Business hours configured correctly in agent settings
- [ ] After-hours behavior configured and tested
- [ ] Transfer numbers verified (staff can receive transfers)
- [ ] Recording storage confirmed (where recordings go, retention policy)
- [ ] Client staff briefed on what AI-handled calls look like in their CRM
- [ ] Rollback plan documented: how to revert to previous phone routing in <5 minutes

## Launch Day

- [ ] Activate voice agent on production phone number
- [ ] Make 2-3 test calls to production number to verify
- [ ] Confirm first real call is logged correctly in CRM
- [ ] Send client a "we're live" message with what to expect

## Week 1: Daily Monitoring

For each day during Week 1:
- [ ] Review ALL call recordings (not just flagged ones)
- [ ] Check CRM for correct data entry on each call
- [ ] Note any call flow issues, misunderstandings, or awkward moments
- [ ] Adjust agent prompt or knowledge base if patterns emerge
- [ ] Send client a daily summary: calls handled, outcomes, any issues

### Red Flags to Watch For
- Agent asking the same question twice in a single call
- CRM records with missing or incorrect fields
- Calls ending abruptly without resolution
- Agent providing information not in the knowledge base
- Transfer failures (dead air, wrong department)
- Caller complaints about the AI experience

## Weeks 2-4: Weekly Optimization

- [ ] Analyze call data: volume, duration, outcomes, conversion rates
- [ ] Identify top 3 improvement opportunities from call review
- [ ] Make prompt or knowledge base adjustments
- [ ] Compare success metrics against baseline targets
- [ ] Send client weekly performance report

## Monthly Steady State

- [ ] Monthly performance review with client
- [ ] Update knowledge base with any new services, pricing, or policies
- [ ] Review and update business hours for holidays or schedule changes
- [ ] Check for prompt drift (agent developing unexpected behaviors)
- [ ] Update success metrics targets based on trends

## Use-Case-Specific Monitoring

### Inbound Receptionist
- Monitor: missed call rate (should decrease), transfer rate (should stabilize), after-hours call volume
- Alert if: transfer failures exceed 5% of transfers, business hours detection is wrong

### Speed-to-Lead
- Monitor: form-to-call latency (target <60s), contact rate, appointment booking rate
- Alert if: latency exceeds 2 minutes, SMS fallback not firing, retry calls not happening

### Database Reactivation
- Monitor: batch completion rate, opt-out rate, re-engagement rate, appointment booking rate
- Alert if: opt-out rate exceeds 10%, DNC violations, batch not completing on schedule
