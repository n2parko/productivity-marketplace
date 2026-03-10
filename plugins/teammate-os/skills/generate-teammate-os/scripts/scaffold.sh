#!/bin/bash
set -euo pipefail

if [ $# -lt 4 ]; then
    echo "Usage: scaffold.sh <workspace_path> <handle> <full_name> <role>"
    echo ""
    echo "Example: scaffold.sh ~/dev/maya-work maya 'Maya Chen' 'Design Lead'"
    exit 1
fi

WORKSPACE="$1"
HANDLE="$2"
FULL_NAME="$3"
ROLE="$4"

MONTH_LOWER=$(date +"%B" | tr '[:upper:]' '[:lower:]')
MONTH_TITLE=$(date +"%B")
YEAR=$(date +"%Y")
TODAY=$(date +"%Y-%m-%d")
DAY_OF_WEEK=$(date +"%A")
SKILL_DIR="$HOME/.cursor/skills"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$PLUGIN_DIR/templates"

echo "=== Scaffolding ${HANDLE}OS ==="
echo "  Workspace: $WORKSPACE"
echo "  Name: $FULL_NAME"
echo "  Handle: $HANDLE"
echo "  Role: $ROLE"
echo ""

# ── Directory structure ──
echo "Creating directory structure..."
mkdir -p "$WORKSPACE"/{goals,projects,todos/"$TODAY",customers}
mkdir -p "$WORKSPACE/.cursor/rules"

# ── Workspace organizer ──
mkdir -p "$WORKSPACE/workspace-organizer"/{lib,scripts}

# ── Skills directory ──
echo "Creating skill directories..."
mkdir -p "$SKILL_DIR/update-${HANDLE}os/scripts"
mkdir -p "$SKILL_DIR/${HANDLE}-personal-context"

# ── Summary ──
echo ""
echo "=== Directory structure created ==="
echo ""
find "$WORKSPACE" -maxdepth 3 -not -path '*/node_modules/*' -not -path '*/.next/*' | head -40
echo ""
echo "Next: The agent will populate files with personalized content."
echo "=== Done ==="
