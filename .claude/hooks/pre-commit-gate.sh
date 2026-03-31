#!/bin/bash
set -e

# Pre-Commit Gate — fires on Bash PreToolUse for git commit commands.
# Requires visible verification evidence before committing.
# Checks: feature branch, source files without tests, UI usability.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Only fire on git commit commands
if ! echo "$COMMAND" | grep -q 'git commit'; then
  exit 0
fi

# Trace log
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/trace-helper.sh"
trace_log "pre-commit" "git commit"

# --- Feature branch enforcement ---
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
WARNINGS=""
if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
  WARNINGS="${WARNINGS}COMMITTING DIRECTLY TO MAIN — use a feature branch and PR instead.\n"
fi

# --- Check staged source files for matching test files ---
STAGED_SOURCE_FILES=$(git diff --cached --name-only --diff-filter=AM -- 'src/lib/*.ts' 'src/agents/*.ts' 'src/app/api/**/*.ts' 2>/dev/null || true)
if [ -n "$STAGED_SOURCE_FILES" ]; then
  while IFS= read -r srcfile; do
    basename=$(basename "$srcfile" .ts)
    case "$basename" in
      prisma|redis|queue|auth|langfuse|secrets|index) continue ;;
    esac
    if echo "$srcfile" | grep -q 'src/app/api/'; then
      if [ ! -f "src/__tests__/api-routes.test.ts" ] && [ ! -f "src/__tests__/${basename}.test.ts" ]; then
        WARNINGS="${WARNINGS}API ROUTE WITHOUT TEST: ${srcfile}\n"
      fi
    elif [ ! -f "src/__tests__/${basename}.test.ts" ]; then
      WARNINGS="${WARNINGS}SOURCE FILE WITHOUT TEST: ${srcfile} → expected src/__tests__/${basename}.test.ts\n"
    fi
  done <<< "$STAGED_SOURCE_FILES"
fi

# --- UI usability check reminder ---
STAGED_UI=$(git diff --cached --name-only -- 'src/app/**/page.tsx' 'src/components/**/*.tsx' 2>/dev/null | head -3)
if [ -n "$STAGED_UI" ]; then
  WARNINGS="${WARNINGS}UI CHANGE DETECTED — run usability checklist:\n"
  WARNINGS="${WARNINGS}   Role check | Scanning distance | Jargon | Attribution | Accessibility\n"
fi

# --- Output warnings if any ---
if [ -n "$WARNINGS" ]; then
  echo ""
  echo "============================================"
  echo "TESTING CHECKS"
  echo "============================================"
  echo -e "$WARNINGS"
  echo "These are WARNINGs — address before merging."
  echo "============================================"
  echo ""
fi

cat <<'GATE'
============================================
PRE-COMMIT GATE — MANDATORY BEFORE COMMITTING
============================================

STOP. Your response MUST contain a visible verification section.

## Post-Build Verification (EACH task, not batched)
- Change type: [which row applies]
- Verification performed: [exact command(s) and output summary]
- Tests: [file + count, or "no testable logic"]
- Build: [passes / fails]
- Result: [pass/fail — if fail, do not commit]

| Change type                        | Minimum verification                              |
|------------------------------------|----------------------------------------------------|
| Pure function (scoring, parsing)   | Unit test passes for that function                 |
| Worker / agent / queue             | Boot the worker + process at least one real job    |
| API route                          | Hit the endpoint, verify response                  |
| Schema migration                   | Verify column exists, Prisma client regenerated    |
| Middleware / auth                  | Protected routes AND existing routes still work    |
| Docs / config only                 | N/A — state "docs/config only"                     |

New pure function or utility? → Write test BEFORE committing.
"Will add tests later" is never acceptable.
============================================
GATE

exit 0
