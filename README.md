# Productivity Marketplace

A Cursor Team Marketplace with Google Workspace plugins powered by the [gws CLI](https://github.com/googleworkspace/cli).

## Setup

1. Install the gws CLI: `npm install -g @googleworkspace/cli`
2. Authenticate: `gws auth setup`
3. Install plugins from this marketplace in Cursor

Each plugin includes a **setup-gws** skill that checks whether the CLI is installed and the user is authenticated before running any commands.

---

## Gmail

Send, read, triage, and manage email.

### Skills

| Skill | Description |
|-------|-------------|
| **setup-gws** | Install and configure the gws CLI for Gmail access |
| **send-email** | Compose and send plain-text email |
| **triage-inbox** | Show unread inbox summary and prioritize messages |
| **search-and-read** | Search messages by query and read full content or threads |
| **manage-labels** | Create, apply, and remove Gmail labels; archive messages |
| **draft-and-reply** | Create drafts for review and reply within existing threads |
| **create-filter** | Set up filters to auto-label, archive, or forward incoming mail |

### Agent

**inbox-manager** — Triages your inbox, drafts replies, and keeps email organized. Checks auth on start, summarizes what needs attention, and never sends without confirmation.

---

## Google Calendar

View agenda, create events, find free time, and manage your schedule.

### Skills

| Skill | Description |
|-------|-------------|
| **setup-gws** | Install and configure the gws CLI for Google Calendar access |
| **view-agenda** | View upcoming events for today, this week, or a custom range |
| **create-event** | Create events with attendees, location, description, and Meet links |
| **find-free-time** | Query free/busy status across multiple people's calendars |
| **reschedule-event** | Move events to a new time and notify attendees |
| **manage-recurring** | Create and modify recurring events with flexible RRULE patterns |

### Agent

**schedule-manager** — Manages your calendar end-to-end. Checks auth on start, views your agenda, finds available slots across attendees, and books or reschedules meetings with confirmation.

---

## Teammate OS

Scaffold a complete personal workspace OS for any teammate — goals, projects, todos, dashboard canvas, Cursor skills, and rules.

### Skills

| Skill | Description |
|-------|-------------|
| **generate-teammate-os** | Interactive scaffold that gathers inputs (name, role, integrations, projects, goals) and creates a full workspace with dashboard, update skill, and Cursor rules |

### Usage

Say "generate os", "set up os for [name]", "onboard teammate", or "new teammate os" to start the interactive setup.

