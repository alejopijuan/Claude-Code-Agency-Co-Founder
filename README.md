# Agency Ops Hub

A Claude Code-powered command center for voice AI agency operators.

Built by [Amplify Voice AI](https://skool.com/amplify-voice-ai) for the community.

## Quick Start

### Prerequisites

- [Cursor](https://cursor.com) installed
- Claude Pro or Max subscription (for Claude Code)
- [Node.js](https://nodejs.org) installed (for the GSD framework)

### Setup (3 minutes)

1. **Clone this repo:**
   ```bash
   git clone https://github.com/AlejoPijuan/voice-ai-agency-ops-hub.git
   cd voice-ai-agency-ops-hub
   ```
   Or download as ZIP from the green "Code" button above.

2. **Open in Cursor:**
   Open the `voice-ai-agency-ops-hub` folder in Cursor.

3. **Run the onboarding wizard:**
   In Cursor's Claude Code panel, type:
   ```
   /agency-ops:onboarding
   ```
   Answer a few questions about your agency. Within 3 minutes, you will have a personalized toolkit ready to use.

4. **Add your first client:**
   ```
   /agency-ops:new-client
   ```

## What You Get

- **Personalized agency identity** — your niche, services, pricing, communication style
- **Client context files** — structured files Claude reads for every interaction
- **12 operations skills** — client briefings, meeting prep, follow-ups, outreach, pipeline, proposals, and more
- **Self-learning system** — skills improve as you use them
- **GSD framework** — plan and build voice AI systems for your clients with `/gsd:new-project`

## Available Skills

| Skill | Description |
| ------- | ------------- |
| `/agency-ops:onboarding` | Stage-gated agency setup wizard |
| `/agency-ops:new-client` | Interactive client file creation |
| `/agency-ops:client-briefing` | Summarize client status before meetings |
| `/agency-ops:meeting-prep` | Generate meeting agendas |
| `/agency-ops:follow-up` | Post-meeting actions and email drafts |
| `/agency-ops:weekly-review` | Cross-client summary and priorities |
| `/agency-ops:outreach` | Track and manage outreach |
| `/agency-ops:pipeline` | View and manage deal pipeline |
| `/agency-ops:proposal` | Generate proposals and artifacts |
| `/agency-ops:voice-agent` | Guide voice agent template selection |
| `/agency-ops:system-build` | Guide n8n system template selection |
| `/agency-ops:lead-gen` | Guide lead gen pipeline setup |
| `/agency-ops:setup-dashboard` | Connect dashboard to Supabase |

## How It Works

Everything is markdown files. No databases, no deployment, no external services required. Your data stays on your machine. Claude reads your agency context and client files to provide personalized assistance through slash commands.

## Community

Join the Amplify Voice AI Skool community for support, live coaching, and to connect with other voice AI agency operators.

[Amplify Voice AI on Skool](https://skool.com/amplify-voice-ai)
