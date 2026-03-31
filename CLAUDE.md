# Agency Ops Hub

A Claude Code-powered command center for voice AI agency operators. Built by Amplify Voice AI.

## Getting Started

Run `/agency-ops:onboarding` to set up your agency.

This is a guided conversation that asks about your niche, experience level, clients, and tech stack, then generates your personalized toolkit. It takes about 3 minutes.

## What This Does

This project helps voice AI agency operators acquire their next client and deliver successfully. It provides:

- **Personalized agency identity** — your niche, services, pricing, communication style
- **Client context management** — structured files that Claude reads for every interaction
- **Operations skills** — slash commands for client briefings, meeting prep, follow-ups, outreach, pipeline tracking, and proposals
- **Self-learning architecture** — skills that get better as you use them, learning your preferences and patterns
- **Delivery templates** — voice agent design docs, system architecture guides, lead gen pipeline templates
- **GSD development framework** — use `/gsd:new-project` to plan and build voice AI systems for your clients

## Available Skills

| Skill | Purpose | When to use |
| ------- | --------- | ------------- |
| `/agency-ops:onboarding` | Stage-gated agency setup wizard | First run, or when resetting agency config |
| `/agency-ops:new-client` | Interactive client file creation | Adding a new client |
| `/agency-ops:client-briefing` | Summarize client status | Before meetings, when context-switching |
| `/agency-ops:meeting-prep` | Generate meeting agenda | Before any client meeting |
| `/agency-ops:follow-up` | Post-meeting actions + email draft | After every client meeting |
| `/agency-ops:weekly-review` | Cross-client summary + priorities | Monday mornings |
| `/agency-ops:outreach` | Track and manage outreach | Daily outreach sessions |
| `/agency-ops:pipeline` | View and manage deal pipeline | Reviewing sales progress |
| `/agency-ops:proposal` | Generate proposals + artifacts | After discovery calls |
| `/agency-ops:voice-agent` | Guide voice agent template selection | When building for a client |
| `/agency-ops:system-build` | Guide n8n system template selection | When building automations |
| `/agency-ops:lead-gen` | Guide lead gen pipeline setup | When setting up prospecting |

## Act / Ask / Absorb

Decision framework for how Claude operates in this project:

- **Act**: Execute autonomously for read-only operations, file-based context updates, skill execution
- **Ask**: Propose and wait for approval on write actions to external systems, contract generation, outreach messages
- **Absorb**: Silently log informational context (meeting notes, client preferences) with no action needed

## Self-Learning

Every skill directory contains `learnings.md` (accumulated knowledge with 30-entry cap) and `references/` (templates, examples). Skills compound through use — the more you use them, the better they get at understanding your preferences and patterns.

## Building for Clients

Use `/gsd:new-project` to plan and build voice AI systems for your clients. GSD (Get Shit Done) is included as your structured development workflow. It handles:

- Project planning with research and requirements
- Phased execution with automatic progress tracking
- Verification that deliverables meet goals

## Project Structure

```
voice-ai-agency-ops-hub/
  CLAUDE.md                        # This file
  README.md                        # Quick start guide
  .claude/
    commands/agency-ops/            # Your skills (slash commands)
      onboarding.md                # Run this first
      client-briefing/
      meeting-prep/
      follow-up/
      weekly-review/
      new-client/
      outreach/
      pipeline/
      proposal/
      voice-agent/
      system-build/
      lead-gen/
    commands/gsd/                   # GSD framework commands
  context/
    agency.md                      # Your agency identity
    clients/
      _template.md                 # Client file template
      _example-client-sunrise-dental.md  # Fictional example
```
