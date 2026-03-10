---
name: generate-teammate-os
description: >-
  Scaffold a personal workspace OS for a new teammate — directory structure,
  goals, projects, canvas dashboard, Cursor skills, and rules. Generates everything
  needed for a teammate to run their own personal OS. Use when user says
  "generate os", "set up os for", "onboard teammate", "create workspace for",
  or "new teammate os".
---

# Generate Teammate OS

Scaffold a complete personal workspace OS for a teammate. The output is a self-contained workspace with goals, projects, todos, a canvas dashboard (single HTML file), and Cursor skills/rules — everything needed to stay organized and sync context from Slack, Calendar, Granola, and Hex.

## Step 0: Gather Inputs (Interactive)

**Always run this step first.** Use the AskQuestion tool to collect structured inputs before scaffolding anything. Ask in batches to keep it fast — don't ask one question at a time.

### Batch 1 — Identity & Location

Ask these conversationally (they're open-ended text, not multiple choice):

> I need a few details to set up the OS:
> 1. **Full name** (e.g., Maya Chen)
> 2. **Handle** — short lowercase id used in paths and branding (e.g., `maya`)
> 3. **Role / title** (e.g., Design Lead)
> 4. **Workspace path** — where to create the workspace (e.g., `~/dev/maya-work`)

Wait for the user's response before continuing.

### Batch 2 — Scope & Integrations

Use AskQuestion with structured options:

```
Question 1: "Which integrations should we set up?"
  Options: [Slack, Google Calendar, Granola (meeting notes), Hex (dashboards), None for now]
  allow_multiple: true

Question 2: "Do you want to pre-populate projects?"
  Options: [Yes — I'll list them next, No — start with an example project]

Question 3: "Do you want to pre-populate monthly goals?"
  Options: [Yes — I'll provide them next, No — start with a template]
```

### Batch 3 — Projects (if "Yes" to projects)

Ask conversationally:

> List your active projects. For each, give me:
> - **Name** (will become the folder slug)
> - **One-liner** describing the project
> - **Lead** (who owns it)
> - **Key Slack channel** (if any)

### Batch 4 — Goals (if "Yes" to goals)

Ask conversationally:

> List your monthly goals. Group them by area. For each goal, list the sub-items as checkboxes. Example:
>
> **Area: Extensibility**
> - Goal: Grow App Store
>   - [ ] Expand to 100 apps
>   - [ ] 20% of users download an app

### Batch 5 — Integration Details (for each selected integration)

**Slack** — ask conversationally:
> What are your key Slack channels to monitor? For each, give me:
> - Channel name (e.g., #proj-app-store)
> - Channel ID (if you know it — otherwise we'll look it up)
> - Priority: High / Medium / Low
> - What topics does it cover?
>
> Also, what's your Slack user ID? (Find it in your Slack profile → three dots → "Copy member ID")

**Hex** — ask conversationally:
> What Hex dashboards should the OS track? For each:
> - Dashboard name (e.g., "App Store")
> - App URL
> - What headline metric should I pull? (e.g., "Total installs this week, WoW trend")

**Calendar** — use AskQuestion:
```
Question: "Which Google Calendar should we sync?"
  Options: [Primary calendar, A specific calendar ID — I'll provide it]
```

**Granola** — no config needed, just confirm it's connected.

### Batch 6 — Work Style (optional)

Use AskQuestion:

```
Question: "Any specific work style preferences?"
  Options: [
    "Use the defaults (exec-level communication, synthesis over questions, lead with answer)",
    "I'll describe my preferences"
  ]
```

If they choose to describe, ask conversationally and incorporate into the work-style rule.

### After Gathering

Confirm the plan before scaffolding:

> Here's what I'll create for **<handle>OS**:
> - Workspace at `<path>`
> - N projects: <list>
> - Goals for <month> <year>
> - Integrations: <list>
> - Dashboard canvas (self-contained HTML)
> - Update skill (`/update-<handle>os`)
> - Cursor rules (personal context + work style)
>
> Ready to scaffold?

Wait for confirmation, then proceed to Step 1.

---

## Step 1: Scaffold Workspace Directory

Run the scaffold script. It creates the directory tree with empty markdown templates.

```bash
bash <plugin_root>/skills/generate-teammate-os/scripts/scaffold.sh \
  "<workspace_path>" \
  "<handle>" \
  "<full_name>" \
  "<role>"
```

> **Note:** `<plugin_root>` is the directory where this plugin is installed. You can find it by locating this SKILL.md file's parent directory — typically `~/.cursor/plugins/cache/*/teammate-os/*/` or `~/.cursor/plugins/local/teammate-os/`.

This creates:

```
<workspace_path>/
├── goals/
│   └── <month>-<year>.md          # Monthly goals template
├── projects/                       # One folder per project
│   └── <project-slug>/
│       ├── overview.md
│       └── next-steps.md
├── todos/                          # Daily todos by date
│   └── YYYY-MM-DD/
│       └── todo.md
├── customers/                      # Customer-specific work
├── workspace-organizer/            # Canvas dashboard generator
│   ├── lib/
│   │   └── workspace.ts           # Reads workspace markdown into structured data
│   ├── scripts/
│   │   ├── generate-canvas.ts     # Generates self-contained HTML canvas
│   │   └── generate-canvas-data.ts # Generates JSON data for data-driven template
│   ├── canvas-template.html       # Data-driven template for CreateCanvas
│   ├── <handle>os.html            # Generated canvas output (do not edit directly)
│   ├── canvas-data.json           # Generated JSON data (do not edit directly)
│   ├── package.json
│   └── tsconfig.json
└── .cursor/
    └── rules/
        ├── personal-context.mdc
        └── work-style.mdc
```

---

## Step 2: Populate Goals

Write `goals/<month>-<year>.md` using the teammate's goals. Follow this structure:

```markdown
# <Month> <Year> Goals — <Full Name>

## Monthly Goals

### <Area 1>

**<Goal Title>**
- [ ] Sub-goal item
- [ ] Sub-goal item

### <Area 2>

**<Goal Title>**
- [ ] Sub-goal item

---

## Goal → Project Map

| Goal | Primary project(s) | Notes |
|------|---------------------|-------|
| <Goal> | `projects/<slug>/` | <context> |

---

## Week of <date range>

### Monday (<date>)
- [ ] Task

### Tuesday (<date>)
- [ ] Task

<!-- ... through Friday -->
```

If goals weren't provided, create a placeholder file with the structure and `<!-- TODO: fill in your goals -->` comments.

---

## Step 3: Populate Projects

For each project provided, create `projects/<slug>/overview.md`:

```markdown
# Project: <Title>

**Lead:** <Name> | **Key people:** <collaborators>
**Slack:** <channels>

---

## Executive Summary

<One paragraph describing the project's goal and current state.>

---

## Next Steps

- [ ] <task>
- [ ] <task>
```

And `projects/<slug>/next-steps.md`:

```markdown
# Next Steps — <Title>

## Current Sprint

- [ ] <task>
```

If no projects provided, create a single example project called `example-project` with the template structure and instructions to rename/replace.

---

## Step 4: Create Today's Todo

Write `todos/YYYY-MM-DD/todo.md` for today:

```markdown
# <Day of week>, <Full date>

## 🔴 High Priority

- [ ] **Set up workspace** — review goals, projects, and dashboard

## 🟡 Medium Priority

- [ ] Review generated goals and fill in missing items
- [ ] Add Slack channel IDs and Hex dashboard URLs

## 🟢 Normal Priority

- [ ] Customize work-style rules to match your preferences
- [ ] Generate the dashboard: `cd workspace-organizer && npm install && npm run canvas`
```

---

## Step 5: Generate Cursor Rules

### Personal Context Rule

Write `<workspace_path>/.cursor/rules/personal-context.mdc`:

```markdown
# Personal Context — <Full Name>

## Work Context
- **Role:** <role>
- **Key collaborators:** <people>
- **Focus areas:** <projects/domains>

## Preferences
- <any stated preferences, or defaults below>
- Synthesis over asking for clarification
- Lead with answer first, then explain thinking

---

*Update this file as you learn more about <first name>'s preferences and context.*
```

### Work Style Rule

Write `<workspace_path>/.cursor/rules/work-style.mdc`:

Use the [work-style-template.md](templates/work-style-template.md) as the base. Customize based on any stated preferences.

---

## Step 6: Generate Cursor Skills

Create skills in `~/.cursor/skills/` scoped to this teammate.

### Update Skill

Create `~/.cursor/skills/update-<handle>os/SKILL.md` following the pattern from [update-skill-template.md](templates/update-skill-template.md). Customize:

- **Workspace path** → the teammate's workspace path
- **Slack channels** → from input (or placeholder)
- **Hex dashboards** → from input (or placeholder)
- **Calendar ID** → from input (or `primary`)
- **Slack user ID** → from input (or placeholder)
- **Goal file path** → `goals/<month>-<year>.md`
- **Project list** → from input

Also create:
- `~/.cursor/skills/update-<handle>os/channels.md` — Slack channels to monitor
- `~/.cursor/skills/update-<handle>os/hex-dashboards.md` — Hex dashboards to pull
- `~/.cursor/skills/update-<handle>os/scripts/snapshot.sh` — Snapshot script (adapt paths)

### Personal Context Skill

Create `~/.cursor/skills/<handle>-personal-context/SKILL.md` — mirrors the rule but as a skill for cross-project use.

---

## Step 7: Generate Dashboard Canvas

The dashboard is a self-contained HTML canvas generated from TypeScript scripts that read the workspace's markdown files and render goals, projects, tasks, and calendar. It supports two rendering modes:

- **Pre-built HTML** (`npm run canvas`) — Generates a complete `<handle>os.html` file
- **Data-driven JSON** (`npm run canvas-data`) — Generates `canvas-data.json` consumed by `canvas-template.html`

Both can be rendered inline in Cursor chat using the `CreateCanvas` tool.

### Copy the workspace-organizer

The scaffold script creates the workspace-organizer directory. After running it, create the following files:

1. **`scripts/generate-canvas.ts`** — Copy from the reference implementation and customize:
   - Change `HEX_DASHBOARDS` array to the teammate's dashboards (or empty array with `[]`)
   - Set the eyebrow text to `"<Handle> work"`
   - Set the h1 and page title to `"<handle>OS"`
   - Set the output filename to `"<handle>os.html"`

2. **`scripts/generate-canvas-data.ts`** — Copy from the reference implementation and customize:
   - Change `HEX_DASHBOARDS` array (same as above)

3. **`canvas-template.html`** — Copy from the reference implementation and customize:
   - Set the eyebrow text and title to match

4. **`lib/workspace.ts`** — Generic, reads from `../` relative to workspace-organizer. No changes needed.

5. **`package.json`** — Ensure these scripts exist:
   - `"canvas": "npx tsx scripts/generate-canvas.ts"`
   - `"canvas-data": "npx tsx scripts/generate-canvas-data.ts"`

### Install and generate

```bash
cd <workspace_path>/workspace-organizer && npm install && npm run canvas
```

### Render inline with CreateCanvas

After generating, render the dashboard inline in Cursor chat:

1. Call `CreateCanvas` with:
   - `title`: `"<handle>OS"`
   - `template`: `<workspace_path>/workspace-organizer/<handle>os.html`

2. Write `{}` to the **data file** returned by CreateCanvas.
3. Write `{}` to the **state file** to dismiss any loading state.

The canvas appears as an interactive dashboard directly in the chat. No browser or dev server needed.

**Alternative (data-driven):** Run `npm run canvas-data` to generate JSON, then use `canvas-template.html` as the CreateCanvas template and write the JSON to the data file. This is useful for live-updating canvases where only the data changes.

---

## Step 8: Report

Present a summary to the user:

```markdown
## <Handle>OS — Setup Complete

### What was created

| Component | Path | Status |
|-----------|------|--------|
| Workspace | `<workspace_path>/` | ✅ |
| Goals | `goals/<month>-<year>.md` | ✅ (needs review) |
| Projects (N) | `projects/*/overview.md` | ✅ |
| Today's todo | `todos/YYYY-MM-DD/todo.md` | ✅ |
| Dashboard canvas | `workspace-organizer/<handle>os.html` | ✅ |
| Cursor rules | `.cursor/rules/` | ✅ |
| Update skill | `~/.cursor/skills/update-<handle>os/` | ✅ |
| Personal context skill | `~/.cursor/skills/<handle>-personal-context/` | ✅ |

### Next steps for <Name>

1. Open `<workspace_path>` in Cursor
2. Review and fill in `goals/<month>-<year>.md`
3. Add Slack channel IDs to `~/.cursor/skills/update-<handle>os/channels.md`
4. Add Hex dashboard URLs to `~/.cursor/skills/update-<handle>os/hex-dashboards.md`
5. Generate the dashboard: `cd workspace-organizer && npm install && npm run canvas`
6. Try `/update-<handle>os` to sync from Slack, Calendar, and Granola

### Customization guide

- **Add a project:** Create `projects/<slug>/overview.md` with the standard template
- **Add a Hex dashboard:** Add a row to `hex-dashboards.md` and update `HEX_DASHBOARDS` in both `scripts/generate-canvas.ts` and `scripts/generate-canvas-data.ts`
- **Add a Slack channel:** Add a row to `channels.md`
- **Change work style:** Edit `.cursor/rules/work-style.mdc`
- **Refresh the canvas:** Run `npm run canvas` in `workspace-organizer/`, then use CreateCanvas to render inline
```

---

## Reference Files

- [templates/work-style-template.md](templates/work-style-template.md) — Default work style rule
- [templates/update-skill-template.md](templates/update-skill-template.md) — Update skill template
- [templates/snapshot-template.sh](templates/snapshot-template.sh) — Snapshot script template
