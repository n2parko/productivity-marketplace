# Teammate OS

Scaffold a complete personal workspace OS for any teammate — goals, projects, todos, a self-contained dashboard canvas, Cursor skills, and rules.

## What it does

Running **generate-teammate-os** creates a fully personalized workspace with:

- **Goals** — Monthly goals with weekly breakdown and health tracking
- **Projects** — Per-project overview and next-steps files
- **Todos** — Daily todos organized by date
- **Dashboard** — Self-contained HTML canvas showing goals, projects, tasks, and calendar
- **Cursor rules** — Personal context and work style rules
- **Update skill** — A generated skill that syncs the workspace from Slack, Calendar, Granola, and Hex

## Skills

| Skill | Description |
|-------|-------------|
| **generate-teammate-os** | Interactive scaffold that gathers inputs and creates the full workspace |

## Usage

Say any of:
- "generate os"
- "set up os for Maya"
- "onboard teammate"
- "create workspace for"
- "new teammate os"

The skill walks through an interactive setup (name, handle, role, integrations, projects, goals) and then scaffolds everything.

## Templates

The plugin includes templates that are used during generation:

| Template | Purpose |
|----------|---------|
| `work-style-template.md` | Default work style Cursor rule |
| `update-skill-template.md` | Template for the teammate's update/sync skill |
| `snapshot-template.sh` | Workspace snapshot script for safe updates |
