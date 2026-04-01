#!/bin/bash
# Auto-save idle checker — runs via macOS launchd every 15 minutes.
# Checks all watched repos for uncommitted changes and runs save-state.sh.
#
# Watched repos are listed below. Add new repos as they're created.

WATCHED_REPOS=(
  "$HOME/src/sunj-labs/canonical"
  "$HOME/src/sunj-labs/poa"
)

for REPO in "${WATCHED_REPOS[@]}"; do
  if [ ! -d "$REPO/.git" ]; then
    continue
  fi

  cd "$REPO"

  # Check for uncommitted changes (excluding .DS_Store)
  DIRTY=$(git status --porcelain 2>/dev/null | grep -v '\.DS_Store' | grep -v 'SESSION_LOCK' | grep -v 'LAST_SAVE' | head -5)
  if [ -z "$DIRTY" ]; then
    continue
  fi

  # Check if a save-state.sh exists in this repo
  SAVE_SCRIPT="$REPO/.claude/hooks/save-state.sh"
  if [ ! -x "$SAVE_SCRIPT" ]; then
    continue
  fi

  # Run save-state quietly
  echo "$(date): Auto-saving $REPO ($( echo "$DIRTY" | wc -l | tr -d ' ') uncommitted files)"
  cd "$REPO" && "$SAVE_SCRIPT" --quiet 2>&1 || true
done
