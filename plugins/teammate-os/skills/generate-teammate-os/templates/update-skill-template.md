# Update Skill Template

Use this as the base for the teammate's update skill (`update-<handle>os/SKILL.md`). Replace all `<PLACEHOLDER>` values.

---

```markdown
---
name: update-<HANDLE>os
description: >-
  Pull latest context from Granola meetings, Slack threads, Google Calendar, and
  Hex dashboards, then update <NAME>'s workspace (todos, project files, goals,
  canvas). Creates a snapshot before changes so you can always revert.
  Use when user says "update", "/update-<HANDLE>os", "sync my workspace",
  "pull latest", "what did I miss", or "catch me up".
---

# Update <HANDLE_TITLE>OS

Sync <NAME>'s workspace with the latest signals from Granola, Slack, Calendar, and Hex, then update local files. Always snapshot first so changes are reversible.

## Snapshot Before Any Changes

**This is mandatory.** Before writing any file, create a snapshot:

\`\`\`bash
bash ~/.cursor/skills/update-<HANDLE>os/scripts/snapshot.sh
\`\`\`

The script copies the current workspace state to `.snapshots/<timestamp>/`. Tell the user the snapshot ID so they can revert later.

### Reverting / Listing

- Revert: `bash ~/.cursor/skills/update-<HANDLE>os/scripts/snapshot.sh revert <timestamp>`
- List: `bash ~/.cursor/skills/update-<HANDLE>os/scripts/snapshot.sh list`

---

## Step 1: Gather Context (parallel)

Launch these data pulls simultaneously using MCP tools.

### 1A. Granola — Recent Meetings

Use the `user-Granola` MCP server.

1. Call `list_meetings` with `time_range: "this_week"` (or `"last_week"` if Monday morning).
2. For each meeting, call `get_meetings` with the IDs.
3. Extract: action items, decisions, open questions, key discussion points.

### 1B. Slack — Key Channels & Threads

Use the `plugin-slack-slack` MCP server. <NAME>'s user_id is `<SLACK_USER_ID>`.

Pull recent activity from key channels listed in [channels.md](channels.md). For each channel:

1. Call `slack_read_channel` with `limit: 20`.
2. For threads with 3+ replies, call `slack_read_thread`.
3. Search for `from:<@SLACK_USER_ID> after:YYYY-MM-DD` (last 3 days).

Extract: action items, decisions, blockers, project context.

### 1C. Calendar — Upcoming Events

Use the `plugin-google-calendar-gws-calendar` MCP server.

1. Call `calendar_events_list` for primary calendar, now through end of week.
2. Cross-reference with Granola notes.

### 1D. Hex — Dashboard Metrics

Use the `plugin-hex-hex` MCP server. See [hex-dashboards.md](hex-dashboards.md).

For each dashboard, create a Hex thread to pull the headline metric. Poll until IDLE. Fire all threads at the start alongside other pulls.

---

## Step 2: Evaluate Goal Health

For each monthly goal in `goals/<GOALS_FILE>`, determine on-track status. Write results to:

\`\`\`
<WORKSPACE>/goals/<GOALS_FILE_STEM>-health.json
\`\`\`

Rating: `green` (on track), `yellow` (at risk), `red` (off track), `gray` (unknown).

---

## Step 3: Synthesize & Categorize

Organize into: Action Items, Decisions, Blockers, Project Updates, Dashboard Health, Goal Health, Calendar Prep, FYIs.

---

## Step 4: Update Workspace Files

### 4A. Update Today's Todo

Create/update `<WORKSPACE>/todos/YYYY-MM-DD/todo.md`.

### 4B. Update Project Files

For each project with new context, append under `## Update — YYYY-MM-DD`.

### 4C. Update Goals

Mark completed items, add notes.

### 4D. Update Dashboard Tiles & Render Canvas Inline

Update the `HEX_DASHBOARDS` array in both canvas scripts:
- `<WORKSPACE>/workspace-organizer/scripts/generate-canvas.ts`
- `<WORKSPACE>/workspace-organizer/scripts/generate-canvas-data.ts`

For each dashboard where a Hex thread returned a metric, update the `metric`, `detail`, `change`, `changeDirection`, `changeSuffix`, and `description` fields.

If a thread failed, keep the existing values unchanged.

**After updating workspace files, render the canvas inline using the Cursor `CreateCanvas` tool:**

1. Regenerate the complete HTML dashboard:
\`\`\`bash
cd <WORKSPACE>/workspace-organizer && npm run canvas
\`\`\`

2. Call `CreateCanvas` with:
   - `title`: "<HANDLE_TITLE>OS"
   - `template`: `<WORKSPACE>/workspace-organizer/<HANDLE>os.html`

3. Write the **data file** (returned by CreateCanvas) with `{}` to signal the canvas is ready.

4. Clear the **state file** (write `{}`) to dismiss any loading state.

The canvas renders inline in the Cursor chat as an interactive dashboard. No browser or server needed.

**Alternative (data-driven template):** For live-updating canvases, use `canvas-template.html` with `npm run canvas-data` to generate JSON, then write the JSON to the CreateCanvas data file. The template renders from JSON data in a `<script type="application/json" id="canvas-data">` tag.

---

## Step 5: Report

Present summary with: snapshot ID, what changed, needs attention, dashboard health, goal health, new action items, upcoming meetings, FYIs.
```

---

Replace these placeholders when generating:

| Placeholder | Value |
|-------------|-------|
| `<HANDLE>` | Lowercase handle (e.g., `maya`) |
| `<HANDLE_TITLE>` | Title-case handle (e.g., `Maya`) |
| `<NAME>` | Full name |
| `<WORKSPACE>` | Absolute workspace path |
| `<SLACK_USER_ID>` | Slack member ID |
| `<GOALS_FILE>` | e.g., `march-2026.md` |
| `<GOALS_FILE_STEM>` | e.g., `march-2026` |
