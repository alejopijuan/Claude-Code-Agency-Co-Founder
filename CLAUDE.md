# Agency Ops Hub

A Claude Code-powered command center for voice AI agency operators. Built by Amplify Voice AI.

## Getting Started

Run `/agency-ops:onboarding` to set up your agency.

This is a guided conversation that asks about your niche, experience level, clients, and tech stack, then generates your personalized toolkit. It takes about 3 minutes.

## What This Does

This project helps voice AI agency operators acquire their next client and deliver successfully. It provides:

- **Personalized agency identity** -- your niche, services, pricing, communication style
- **Client context management** -- structured files that Claude reads for every interaction
- **Operations skills** -- slash commands for client briefings, meeting prep, follow-ups, outreach, pipeline tracking, and proposals
- **Self-learning architecture** -- skills that get better as you use them, learning your preferences and patterns
- **Delivery templates** -- voice agent design docs, system architecture guides, lead gen pipeline templates
- **GSD development framework** -- use `/gsd:new-project` to plan and build voice AI systems for your clients

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
| `/agency-ops:voice-agent` | Guide voice agent design, customization, and model-specific Retell prompt creation | When building a voice agent for a client |
| `/agency-ops:prompt-trim` | Trim voice agent prompts with 3 tiers (conservative/moderate/aggressive) | When a prompt exceeds token targets, or to optimize an existing prompt |
| `/agency-ops:system-build` | Guide n8n system architecture selection and customization | When building automations for a client |
| `/agency-ops:lead-gen` | Guide lead generation strategy selection for your niche | When setting up prospecting |
| `/agency-ops:setup-dashboard` | Connect dashboard to Supabase | When setting up live data visualization |

## Act / Ask / Absorb

Decision framework for how Claude operates in this project:

- **Act**: Execute autonomously for read-only operations, file-based context updates, skill execution
- **Ask**: Propose and wait for approval on write actions to external systems, contract generation, outreach messages
- **Absorb**: Silently log informational context (meeting notes, client preferences) with no action needed

## Self-Learning

Every skill directory contains `learnings.md` (accumulated knowledge with 30-entry cap) and `references/` (templates, examples). Skills compound through use -- the more you use them, the better they get at understanding your preferences and patterns.

## Delivery Templates

Templates for building and delivering voice AI solutions:
- `templates/voice-agents/` -- System design documents for inbound receptionist, speed-to-lead, and database reactivation
- `templates/systems/` -- n8n architecture guides for pre-call and post-call automations
- `templates/lead-gen/` -- Lead generation strategy guide

Run `/agency-ops:voice-agent`, `/agency-ops:system-build`, or `/agency-ops:lead-gen` to use these templates interactively.

## Building for Clients

Use `/gsd:new-project` to plan and build voice AI systems for your clients. GSD (Get Shit Done) is included as your structured development workflow. It handles:

- Project planning with research and requirements
- Phased execution with automatic progress tracking
- Verification that deliverables meet goals

## Project Structure

```
Claude-Code-Agency-Co-Founder/
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
      prompt-trim/
      system-build/
      lead-gen/
      setup-dashboard/
    commands/gsd/                   # GSD framework commands
  context/
    agency.md                      # Your agency identity
    clients/
      _template.md                 # Client file template
      _example-sunrise-dental/
        sunrise-dental.md          # Fictional example
    outreach/
      _template.md                 # Outreach lead template
      _example-lead.md             # Fictional example lead
    pipeline/
      _template.md                 # Pipeline deal template
      _example-deal.md             # Fictional example deal
    sops/                          # Standard operating procedures
      client-onboarding.md
      meeting-protocol.md
      scope-management.md
      testimonial-collection.md
  templates/
    voice-agents/                  # Voice agent system design documents
      _shared/                    # Shared testing, go-live, KB gathering
      retell-configs/             # Templatized Retell JSON configs
      retell-prompts/             # Templatized system prompts
      inbound-receptionist.md
      speed-to-lead.md
      database-reactivation.md
    systems/                      # n8n architecture guides
      _shared/                    # Supabase schema extension
      pre-call-automation.md
      post-call-reporting.md
    lead-gen/                     # Lead gen strategy guide
      lead-gen-strategy.md
      google-maps-scraping.md
```
