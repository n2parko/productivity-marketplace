#!/bin/bash
set -euo pipefail

# ── Configuration (set during generation) ──
WORKSPACE="__WORKSPACE_PATH__"
SNAPSHOT_DIR="$HOME/.cursor/skills/update-__HANDLE__os/.snapshots"
MAX_SNAPSHOTS=20

usage() {
    echo "Usage:"
    echo "  snapshot.sh              Create a new snapshot"
    echo "  snapshot.sh list         List available snapshots"
    echo "  snapshot.sh revert <id>  Revert workspace to a snapshot"
    echo "  snapshot.sh diff <id>    Show files changed since snapshot"
    echo "  snapshot.sh prune        Remove oldest snapshots beyond $MAX_SNAPSHOTS"
}

create_snapshot() {
    local timestamp
    timestamp=$(date +"%Y%m%d-%H%M%S")
    local dest="$SNAPSHOT_DIR/$timestamp"

    mkdir -p "$dest"

    rsync -a \
        --exclude='.next/' \
        --exclude='node_modules/' \
        --exclude='.git/' \
        --exclude='workspace-organizer/' \
        "$WORKSPACE/" "$dest/workspace/"

    cat > "$dest/manifest.txt" <<EOF
snapshot_id: $timestamp
created_at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
workspace: $WORKSPACE
files_count: $(find "$dest/workspace" -type f | wc -l | tr -d ' ')
EOF

    echo "$timestamp"

    local count
    count=$(ls -1d "$SNAPSHOT_DIR"/*/manifest.txt 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -gt "$MAX_SNAPSHOTS" ]; then
        prune_snapshots
    fi
}

list_snapshots() {
    if [ ! -d "$SNAPSHOT_DIR" ] || [ -z "$(ls -A "$SNAPSHOT_DIR" 2>/dev/null)" ]; then
        echo "No snapshots found."
        return
    fi

    echo "Available snapshots:"
    echo "--------------------"
    for manifest in "$SNAPSHOT_DIR"/*/manifest.txt; do
        local dir
        dir=$(dirname "$manifest")
        local id
        id=$(basename "$dir")
        local created
        created=$(grep "created_at:" "$manifest" | cut -d' ' -f2)
        local files
        files=$(grep "files_count:" "$manifest" | cut -d' ' -f2)
        local size
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        echo "  $id  |  $created  |  $files files  |  $size"
    done
}

revert_snapshot() {
    local id="$1"
    local src="$SNAPSHOT_DIR/$id/workspace"

    if [ ! -d "$src" ]; then
        echo "ERROR: Snapshot '$id' not found."
        echo "Run 'snapshot.sh list' to see available snapshots."
        exit 1
    fi

    local pre_revert_id
    pre_revert_id=$(create_snapshot)
    echo "Pre-revert safety snapshot created: $pre_revert_id"

    rsync -a --delete \
        --exclude='.next/' \
        --exclude='node_modules/' \
        --exclude='.git/' \
        --exclude='workspace-organizer/' \
        "$src/" "$WORKSPACE/"

    echo "Reverted workspace to snapshot: $id"
    echo "To undo this revert, use: snapshot.sh revert $pre_revert_id"
}

diff_snapshot() {
    local id="$1"
    local src="$SNAPSHOT_DIR/$id/workspace"

    if [ ! -d "$src" ]; then
        echo "ERROR: Snapshot '$id' not found."
        exit 1
    fi

    diff -rq "$src" "$WORKSPACE" \
        --exclude='.next' \
        --exclude='node_modules' \
        --exclude='.git' \
        --exclude='workspace-organizer' \
        2>/dev/null || true
}

prune_snapshots() {
    local snapshots
    snapshots=($(ls -1d "$SNAPSHOT_DIR"/*/manifest.txt 2>/dev/null | sort))
    local count=${#snapshots[@]}
    local to_remove=$((count - MAX_SNAPSHOTS))

    if [ "$to_remove" -le 0 ]; then
        echo "Nothing to prune ($count/$MAX_SNAPSHOTS snapshots)."
        return
    fi

    echo "Pruning $to_remove oldest snapshot(s)..."
    for ((i=0; i<to_remove; i++)); do
        local dir
        dir=$(dirname "${snapshots[$i]}")
        local id
        id=$(basename "$dir")
        rm -rf "$dir"
        echo "  Removed: $id"
    done
}

case "${1:-create}" in
    create)
        create_snapshot
        ;;
    list)
        list_snapshots
        ;;
    revert)
        if [ -z "${2:-}" ]; then
            echo "ERROR: Provide a snapshot ID to revert to."
            usage
            exit 1
        fi
        revert_snapshot "$2"
        ;;
    diff)
        if [ -z "${2:-}" ]; then
            echo "ERROR: Provide a snapshot ID to diff against."
            usage
            exit 1
        fi
        diff_snapshot "$2"
        ;;
    prune)
        prune_snapshots
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        echo "Unknown command: $1"
        usage
        exit 1
        ;;
esac
