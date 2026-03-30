# Meeting Protocol SOP

How to prepare for, run, and follow up on client meetings so nothing gets lost and every interaction moves the project forward.

## 1. Pre-Meeting Prep (15 Minutes Before)

Do this before every client meeting, no exceptions.

1. **Run the meeting prep skill.** Execute `/agency-ops:meeting-prep {client-name}` to generate a structured agenda based on the client's current status, open commitments, and recent activity.
2. **Pull up recent data.** Open your voice AI platform dashboard and note:
   - Total calls handled since last meeting
   - Conversion rate (calls to appointments/outcomes)
   - Any failed calls or errors
   - Notable call recordings worth discussing
3. **Review the commitments log.** Open the client file at `context/clients/{client-name}.md` and check:
   - Are there overdue commitments (yours or theirs)?
   - Any "In Progress" items that should be "Done" by now?
   - Commitments due before the next meeting?
4. **Check for blockers.** Are you waiting on anything from the client? CRM access, content updates, approval on a call flow change? Note these to raise early in the meeting.
5. **Have the client file open.** Keep `context/clients/{client-name}.md` visible during the meeting for quick reference and live note-taking.

## 2. Agenda Structure

Use this structure for every meeting. Adjust time allocations based on meeting type (see Section 5).

1. **Status Check (2 minutes)**
   - "Here's where we are..." Quick summary of what is live, what was shipped since last meeting, and overall health.
   - Lead with wins. If the agent booked 15 appointments this week, say that first.

2. **Open Action Items (5-10 minutes)**
   - Walk through the commitments log. Review each open item:
     - Items assigned to you: share status and expected completion.
     - Items assigned to the client: ask for updates. If overdue, address directly but diplomatically.
   - Mark completed items as "Done" in your notes.

3. **Updates and Discussion (10-15 minutes)**
   - Share performance data with context, not just numbers. "The agent handled 47 calls this week, up from 38 last week. Conversion rate held steady at 66%."
   - Discuss any issues that came up: call quality problems, integration hiccups, edge cases the agent did not handle well.
   - Present any recommendations: call flow adjustments, new qualifying questions, expanded hours.
   - If the client raises a request that is outside scope, use the Scope Management SOP to handle it.

4. **Questions (5 minutes)**
   - "What questions do you have?" Give them space to bring up anything not covered.
   - If they raise something you need to research, say "Let me look into that and get back to you by [date]" and add it to commitments.

5. **Next Steps (2 minutes)**
   - Summarize all action items with owners and due dates. Read them back.
   - Confirm the next meeting date and time.
   - "Anything else before we wrap up?"

## 3. Note-Taking Format

During the meeting, capture notes in this structure. You will paste these into the client file after the meeting.

```markdown
### YYYY-MM-DD -- [Meeting Type]

**Attendees:** [names]
**Duration:** [X] min

- [Key discussion point 1]
- [Key discussion point 2]
- [Key discussion point 3]
- **Action:** [action item with owner and due date]
- **Action:** [action item with owner and due date]
- **Decision:** [any decisions made, with context]
```

Tips for good meeting notes:
- Write in bullet points, not paragraphs. Future-you will thank you.
- Capture decisions with their reasoning, not just the decision itself. "Decided to delay after-hours launch by 1 week because Mike is on vacation and cannot test" is better than "Delayed after-hours."
- Note who said what when it matters (especially for decisions and commitments).
- If a client says something quotable about results, write it down exactly. It might become a testimonial later.

## 4. Follow-Up Timeline

After every meeting, follow this sequence:

1. **Within 30 minutes:** Jot down any notes you did not capture during the meeting while they are fresh.
2. **Within 2 hours:** Run `/agency-ops:follow-up {client-name}` to process your notes. This will:
   - Generate a summary of action items with owners and due dates.
   - Draft a follow-up email you can send to the client.
   - Update the commitments log in the client file (append-only).
3. **Same day:** Send the follow-up email to the client. The email should include:
   - Brief recap of key discussion points.
   - Clear list of action items (who owes what, by when).
   - Next meeting date confirmation.
4. **Within 24 hours:** Start working on your action items. The first 24 hours of momentum matter.
5. **Between meetings:** If a commitment is going to be late, proactively reach out to the client before the due date. "Hey Mike, the CRM integration is taking longer than expected because of [reason]. New ETA is [date]." This builds trust.

## 5. Meeting Types

### Weekly Check-in (30 minutes)
- **When:** Active projects in build or first month post-launch.
- **Focus:** Status updates, immediate action items, quick decisions.
- **Attendees:** Your main point of contact (e.g., office manager).
- **Prep time:** 10 minutes.

### Biweekly Check-in (30 minutes)
- **When:** Stable projects past the first month.
- **Focus:** Performance review, optimization opportunities, upcoming needs.
- **Attendees:** Main point of contact.
- **Prep time:** 15 minutes.

### Monthly Review (45 minutes)
- **When:** First [day] of each month.
- **Focus:** Performance metrics deep dive, ROI analysis, strategic planning, upcoming projects.
- **Attendees:** Main contact + decision maker (if different). Include marketing contact if relevant.
- **Prep time:** 30 minutes. Pull together a month-over-month performance comparison.

### Quarterly Business Review (60 minutes)
- **When:** Every 3 months.
- **Focus:** Big-picture results, strategic roadmap, contract renewal, expansion opportunities.
- **Attendees:** Decision maker + key stakeholders.
- **Prep time:** 45 minutes. Prepare a polished deck or summary with ROI data, call volume trends, and recommendations for next quarter.

### Ad-Hoc (15 minutes)
- **When:** Client requests a quick call for a specific issue.
- **Focus:** Single topic. Resolve and move on.
- **Attendees:** Whoever is needed.
- **Prep time:** 5 minutes. Read the client file and recent commitments.

---

*Cross-references: `/agency-ops:meeting-prep`, `/agency-ops:follow-up`, `/agency-ops:client-briefing`, `context/sops/scope-management.md`*
