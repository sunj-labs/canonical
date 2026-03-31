#!/bin/bash
set -e

# Pre-Build Gate — fires on first Edit/Write per session.
# Requires visible SDLC evidence before writing code.
# Loads relevant design diagrams contextually based on file being edited.

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

# Skip for non-source files (hooks, config, docs, memory, github workflows)
if echo "$FILE_PATH" | grep -qE '\.(sh|json)$|/\.claude/|/memory/|/docs/|/\.github/|CLAUDE\.md|MEMORY\.md'; then
  exit 0
fi

# Trace log
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/trace-helper.sh"
trace_log "pre-build" "$TOOL_NAME $FILE_PATH"

# --- Feature branch enforcement ---
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
  echo ""
  echo "============================================"
  echo "WRITING TO MAIN BRANCH — CREATE A FEATURE BRANCH"
  echo "============================================"
  echo ""
  echo "You are editing source code directly on main."
  echo "All work should happen on a feature branch:"
  echo "  git checkout -b feature/ISSUE-NNN-description"
  echo "============================================"
  echo ""
fi

# Fire full gate first time per session, lightweight reminder on subsequent edits
FLAG_FILE="/tmp/claude-pre-build-gate-${SESSION_ID}"
DOCS_DIR="$CWD/docs/design"

if [ -f "$FLAG_FILE" ]; then
  # Subsequent edit — lightweight per-task reminder
  cat <<'PERTASK'
============================================
PRE-BUILD — PER-TASK CHECK
============================================

Before this edit, confirm:
- Building against: [ticket # or "trivial — logged in commit"]
- Temperance: Simplest correct approach? Brute-forcing?
- UI surface impacted? If yes, is IA/state diagram current?
- Env vars needed? Set?
============================================
PERTASK

else
  # First edit this session — full SDLC checkpoint
  touch "$FLAG_FILE"

  cat <<'GATE'
============================================
PRE-BUILD GATE — MANDATORY BEFORE WRITING CODE
============================================

You are about to write/edit source code. STOP.

YOUR RESPONSE must contain ALL of the following sections as visible text
BEFORE this Edit/Write and any subsequent code changes:

## SDLC Checkpoint
- Building against: [ticket #NNN — title, or "no ticket" with justification]
- Spec current?: [yes/no — if no, what needs updating first?]
- Design diagrams: [which need updating and why, or "none — because X"]
- Engineering principles: [any SoC/abstraction/cohesion concerns? or "clean"]

## Environment Check
- External credentials needed?: [OAuth, API keys, tokens, etc.]
- Are they set?: [check NOW — if empty, flag blocker before writing code]

## Requirements Check
- New requirements surfaced?: [yes → where logged | no]
- Untracked work?: [am I coding something not on any ticket? if yes, log it first]

## Test Plan
- Testable logic?: [yes/no — pure functions, utilities, parsers = yes]
- Test approach: [which test file will cover this? new or existing?]

If this is a bug fix, you must ALSO have completed the Bug Diagnosis
(Is/Is Not + Five Whys) before proceeding.

Only after writing these sections may you proceed to write code.
============================================
GATE
fi

# === Contextual diagram loading ===
echo ""
echo "=== RELEVANT DESIGN DIAGRAMS (verify against these) ==="
echo ""

LOADED=0

# Schema / Prisma / migration → load ERD
if echo "$FILE_PATH" | grep -qiE 'prisma|schema|model|migration'; then
  [ -f "$DOCS_DIR/erd.md" ] && { echo "### ERD (triggered by: schema/model file)"; head -80 "$DOCS_DIR/erd.md" 2>/dev/null; echo ""; LOADED=1; }
fi

# Queue / worker / agent → load Sequence + Component diagrams
if echo "$FILE_PATH" | grep -qiE 'worker|queue|agent|job|bull|cron|ingest'; then
  [ -f "$DOCS_DIR/sequences/"*.md ] 2>/dev/null && { echo "### Sequence diagrams (triggered by: worker/agent file)"; ls "$DOCS_DIR/sequences/"*.md 2>/dev/null; echo ""; LOADED=1; }
  [ -f "$DOCS_DIR/component-diagram.md" ] && { echo "### Component Diagram"; head -60 "$DOCS_DIR/component-diagram.md" 2>/dev/null; echo ""; LOADED=1; }
fi

# Docker / deploy / infra → load Component + Deployment diagrams
if echo "$FILE_PATH" | grep -qiE 'docker|deploy|infra|compose|Dockerfile|workflow'; then
  [ -f "$DOCS_DIR/component-diagram.md" ] && { echo "### Component Diagram (triggered by: infra file)"; head -60 "$DOCS_DIR/component-diagram.md" 2>/dev/null; echo ""; LOADED=1; }
fi

# Auth / user / role → load Use Case diagram
if echo "$FILE_PATH" | grep -qiE 'auth|user|role|permission|session'; then
  [ -f "$DOCS_DIR/use-cases.md" ] && { echo "### Use Cases (triggered by: auth/role file)"; head -60 "$DOCS_DIR/use-cases.md" 2>/dev/null; echo ""; LOADED=1; }
fi

# Page route → UX check + E2E reminder
if echo "$FILE_PATH" | grep -qiE 'src/app/.*/page\.tsx'; then
  echo "### UX Check (triggered by: page route file)"
  echo "- Does a state diagram exist for this page?"
  echo "- Is this page in the entity model / screen map?"
  echo "- Are components named after domain objects?"
  echo "- Run /ia-model if navigation or screen structure is changing."
  echo ""
  echo "### E2E Smoke Test"
  echo "User-facing pages MUST be covered by E2E smoke tests."
  echo ""
  LOADED=1
fi

# API route → E2E reminder
if echo "$FILE_PATH" | grep -qiE 'src/app/api/.*/route\.ts'; then
  echo "### E2E Smoke Test (triggered by: API route file)"
  echo "API routes MUST be covered by E2E smoke tests."
  echo "- Protected route: add auth gate test"
  echo "- Public route: add response shape test"
  echo ""
  LOADED=1
fi

# Schema change → entity model + migration reminder
if echo "$FILE_PATH" | grep -qiE 'prisma/schema'; then
  echo "### Entity Model Check (triggered by: schema file)"
  echo "- Has the entity been added to the object model?"
  echo "- Does this entity need a UI surface?"
  echo "- Run /ia-model if adding a new entity."
  echo ""
  echo "### MIGRATION REQUIRED"
  echo "After editing schema, run: npx prisma migrate dev --name descriptive_name"
  echo "NEVER use prisma db push. It causes schema drift."
  echo ""
  LOADED=1
fi

if [ "$LOADED" -eq 0 ]; then
  echo "(No diagram matched: $FILE_PATH)"
  echo "If this change introduces new objects, async flows, or lifecycle changes,"
  echo "manually read the relevant diagram from docs/design/ before proceeding."
fi

echo ""
echo "=== END DIAGRAMS ==="

exit 0
