#!/bin/bash
set -e

# Save State — graceful checkpoint of all work in progress.
# Called by: session-end hook, idle auto-save loop, or manually.
#
# What it does:
#   1. Commits any uncommitted changes with a checkpoint message
#   2. Pushes to remote
#   3. Writes LAST_SAVE with timestamp + machine info
#   4. Removes SESSION_LOCK
#
# Usage:
#   .claude/hooks/save-state.sh              # from repo root
#   .claude/hooks/save-state.sh --quiet      # suppress output (for auto-save)

QUIET=""
if [ "$1" = "--quiet" ]; then
  QUIET="true"
fi

log() {
  [ -z "$QUIET" ] && echo "$1"
}

# Trace log
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/trace-helper.sh" ]; then
  source "$SCRIPT_DIR/trace-helper.sh"
  trace_log "save-state" "checkpoint"
fi

# 1. Commit uncommitted changes
DIRTY=$(git status --porcelain 2>/dev/null | grep -v '\.DS_Store' | grep -v 'SESSION_LOCK' | head -20)
if [ -n "$DIRTY" ]; then
  # Stage tracked modified files + any docs/ or chronicle/ changes
  git add -u 2>/dev/null || true
  git add docs/ chronicle/ specs/ 2>/dev/null || true
  git add .claude/projects/*/memory/ 2>/dev/null || true

  STAGED=$(git diff --cached --name-only 2>/dev/null)
  if [ -n "$STAGED" ]; then
    TIMESTAMP=$(date +%Y-%m-%dT%H:%M:%S)
    MACHINE=$(hostname -s 2>/dev/null || echo "unknown")
    FILE_COUNT=$(echo "$STAGED" | wc -l | tr -d ' ')

    git commit -m "chore: auto-save checkpoint ($FILE_COUNT files) — $MACHINE $TIMESTAMP" 2>/dev/null
    log "Committed $FILE_COUNT files"
  fi
fi

# 2. Push to remote
BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
REMOTE_EXISTS=$(git remote 2>/dev/null | head -1)
if [ -n "$REMOTE_EXISTS" ]; then
  git push origin "$BRANCH" 2>/dev/null && log "Pushed to origin/$BRANCH" || log "Push failed (offline?)"
fi

# 3. Write LAST_SAVE
LAST_SAVE_FILE=".claude/LAST_SAVE"
TIMESTAMP=$(date +%Y-%m-%dT%H:%M:%S%z)
MACHINE=$(hostname -s 2>/dev/null || echo "unknown")
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
LAST_COMMIT=$(git log --oneline -1 2>/dev/null || echo "none")

cat > "$LAST_SAVE_FILE" <<SAVE
timestamp: $TIMESTAMP
machine: $MACHINE
branch: $BRANCH
last_commit: $LAST_COMMIT
SAVE

log "State saved: $TIMESTAMP on $MACHINE"

# 4. Remove session lock
rm -f .claude/SESSION_LOCK 2>/dev/null

exit 0
