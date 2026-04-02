#!/bin/bash
set -e

# Session Start hook — injects reflection prompt so the agent
# cannot skip the Reflect → Plan protocol.
# Also detects abrupt termination and forces missed session-end work.

INPUT=$(cat)
SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

cd "$CWD"

# Trace log
source "$(dirname "$0")/trace-helper.sh"
trace_log "session-start" "$SOURCE"

echo "============================================"
echo "SESSION START — MANDATORY REFLECT → PLAN"
echo "============================================"
echo ""
echo "You MUST run the Session Start protocol before doing ANY other work."
echo "Do NOT skip this. Do NOT jump to answering the user's question first."
echo ""

# === Last save state ===
LAST_SAVE_FILE=".claude/LAST_SAVE"
if [ -f "$LAST_SAVE_FILE" ]; then
  SAVE_TIMESTAMP=$(grep '^timestamp:' "$LAST_SAVE_FILE" | cut -d' ' -f2-)
  SAVE_MACHINE=$(grep '^machine:' "$LAST_SAVE_FILE" | cut -d' ' -f2-)
  SAVE_BRANCH=$(grep '^branch:' "$LAST_SAVE_FILE" | cut -d' ' -f2-)
  SAVE_COMMIT=$(grep '^last_commit:' "$LAST_SAVE_FILE" | cut -d' ' -f2-)
  echo "### LAST SAVE STATE"
  echo ""
  echo "Saved: $SAVE_TIMESTAMP"
  echo "Machine: $SAVE_MACHINE"
  echo "Branch: $SAVE_BRANCH"
  echo "Last commit: $SAVE_COMMIT"
  echo ""
else
  echo "### NO PREVIOUS SAVE STATE FOUND"
  echo ""
  echo "This may be the first session, or save-state has never run."
  echo "Proceed with caution — check git log for context."
  echo ""
fi

# === Write session lock ===
LOCK_FILE=".claude/SESSION_LOCK"
MACHINE=$(hostname -s 2>/dev/null || echo "unknown")
echo "machine: $MACHINE" > "$LOCK_FILE"
echo "timestamp: $(date +%Y-%m-%dT%H:%M:%S%z)" >> "$LOCK_FILE"
echo "pid: $$" >> "$LOCK_FILE"

# === Abrupt stop detection ===
DIRTY_TREE=$(git status --porcelain 2>/dev/null | head -5)

if [ -n "$DIRTY_TREE" ]; then
  echo "### ABRUPT STOP DETECTED — RECOVERY NEEDED"
  echo ""
  echo "Uncommitted changes found:"
  echo "$DIRTY_TREE"
  echo ""
  echo "→ Ask the user: commit these, stash, or discard?"
  echo ""
  echo "Session-end protocol was likely skipped. Check:"
  echo "- Are any issues stuck in 'In Progress' that should be Done?"
  echo "- Was memory saved from the last session?"
  echo ""
fi

# === Session lock check ===
if [ -f ".claude/SESSION_LOCK" ]; then
  LOCK_AGE=$(( $(date +%s) - $(stat -f %m ".claude/SESSION_LOCK" 2>/dev/null || echo "0") ))
  if [ "$LOCK_AGE" -lt 7200 ]; then
    echo "### ANOTHER SESSION MAY BE ACTIVE"
    echo ""
    echo "SESSION_LOCK exists and is $(( LOCK_AGE / 60 )) minutes old."
    echo "Another agent or session may be working in this repo."
    echo ""
    echo "→ Ask the user before proceeding. Do NOT overwrite another session's work."
    echo ""
  else
    echo "### STALE SESSION LOCK ($(( LOCK_AGE / 3600 )) hours old)"
    echo ""
    echo "Previous session likely crashed. Proceeding with caution."
    echo ""
  fi
fi

# === Check for missing chronicle ===
# Look for chronicle in both platform-docs style and app-repo style locations
for CHRONICLE_DIR in "chronicle" "docs/chronicle"; do
  if [ -d "$CHRONICLE_DIR" ]; then
    TODAY=$(date +%Y-%m-%d)
    LAST_CHRONICLE=$(ls -1 "$CHRONICLE_DIR"/*.md 2>/dev/null | sort | tail -1 | xargs basename 2>/dev/null | cut -c1-10)

    if [ -n "$LAST_CHRONICLE" ]; then
      COMMITS_SINCE_CHRONICLE=$(git log --oneline --since="$LAST_CHRONICLE" 2>/dev/null | wc -l | tr -d ' ')
      TODAY_CHRONICLE=$(ls -1 "$CHRONICLE_DIR"/${TODAY}*.md 2>/dev/null | wc -l | tr -d ' ')

      if [ "$COMMITS_SINCE_CHRONICLE" -ge 3 ] && [ "$TODAY_CHRONICLE" -eq 0 ]; then
        echo "### CHRONICLE ENTRY MISSING"
        echo ""
        echo "Last chronicle: $LAST_CHRONICLE ($COMMITS_SINCE_CHRONICLE commits since)"
        echo "No chronicle for today ($TODAY)."
        echo ""
        echo "Session-end protocol was skipped. Write the missing chronicle now."
        echo ""
      fi
    fi
    break
  fi
done

# === Check for missing danger mode summary ===
DANGER_DIR="docs/danger-mode-summaries"
if [ -d "$DANGER_DIR" ]; then
  TODAY=$(date +%Y-%m-%d)
  COMMITS_TODAY=$(git log --oneline --since="$TODAY" 2>/dev/null | wc -l | tr -d ' ')
  TODAY_DANGER=$(ls -1 "$DANGER_DIR"/${TODAY}.md 2>/dev/null | wc -l | tr -d ' ')

  if [ "$COMMITS_TODAY" -ge 3 ] && [ "$TODAY_DANGER" -eq 0 ]; then
    echo "### DANGER MODE SUMMARY MAY BE MISSING"
    echo ""
    echo "$COMMITS_TODAY commits today but no danger mode summary."
    echo "If the previous session used auto-complete, write the summary."
    echo ""
  fi
fi

# === Architect review check ===
for REVIEW_DIR in "docs/architecture/reviews" "architecture/reviews"; do
  if [ -d "$REVIEW_DIR" ]; then
    LAST_REVIEW=$(ls -1 "$REVIEW_DIR"/*.md 2>/dev/null | sort | tail -1 | xargs basename 2>/dev/null | cut -c1-10)
    if [ -n "$LAST_REVIEW" ]; then
      COMMITS_SINCE=$(git log --oneline --since="$LAST_REVIEW" 2>/dev/null | wc -l | tr -d ' ')
      if [ "$COMMITS_SINCE" -ge 10 ]; then
        echo "### ARCHITECT REVIEW IS YOUR FIRST TASK"
        echo ""
        echo "$COMMITS_SINCE commits since last review ($LAST_REVIEW)."
        echo ""
        echo "Run /architect-review BEFORE any other work."
        echo "This is NOT optional."
        echo ""
      fi
    fi
    break
  fi
done

# === Canonical evolution issues (canonical sessions only) ===
# Scans canonical AND all known child repos for promotion proposals
REPO_NAME_CHECK=$(gh repo view --json name -q '.name' 2>/dev/null || echo "")
if [ "$REPO_NAME_CHECK" = "platform-docs" ] || [ "$REPO_NAME_CHECK" = "canonical" ]; then
  CHILD_REPOS="sunj-labs/poa"  # add new repos here as they're created
  ALL_EVOLUTION=""

  # Check canonical's own issues
  CANONICAL_ISSUES=$(gh issue list -R "sunj-labs/canonical" --label "canonical-evolution" --state open --limit 10 2>/dev/null)
  if [ -n "$CANONICAL_ISSUES" ]; then
    ALL_EVOLUTION="${ALL_EVOLUTION}\n  From canonical:\n${CANONICAL_ISSUES}\n"
  fi

  # Check each child repo for proposals
  for CHILD in $CHILD_REPOS; do
    CHILD_ISSUES=$(gh issue list -R "$CHILD" --label "canonical-evolution" --state open --limit 10 2>/dev/null)
    if [ -n "$CHILD_ISSUES" ]; then
      ALL_EVOLUTION="${ALL_EVOLUTION}\n  From ${CHILD}:\n${CHILD_ISSUES}\n"
    fi
  done

  if [ -n "$ALL_EVOLUTION" ]; then
    echo "### CANONICAL EVOLUTION — PENDING PROMOTIONS"
    echo ""
    echo -e "$ALL_EVOLUTION"
    echo "Review and resolve these. Child repo proposals need ingestion"
    echo "into canonical if globally applicable."
    echo ""
  fi
fi

# === Standard reflection steps ===
echo "### Step 1: Read memory"
echo "Read project memory from .claude/ directory"
echo ""
echo "### Step 2: Recent commits"
git log --oneline -5 2>/dev/null || echo "(no git history)"
echo ""
echo "### Step 3: Open issues"
REPO_NAME=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null || echo "")
if [ -n "$REPO_NAME" ]; then
  gh issue list -R "$REPO_NAME" --limit 10 2>/dev/null || echo "(issues unavailable)"
else
  echo "(gh repo not detected — check open issues manually)"
fi
echo ""
echo "### Step 4: Summarize + propose 1-3 items, then WAIT for human confirmation."
echo "============================================"

exit 0
