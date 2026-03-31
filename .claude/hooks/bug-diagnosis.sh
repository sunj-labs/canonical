#!/bin/bash
set -e

# Bug Diagnosis hook — fires on UserPromptSubmit.
# Safety net: keyword detection injects diagnosis reminder.
#
# IMPORTANT: This hook is a SAFETY NET, not the process.
# The agent is responsible for self-triggering diagnosis when
# it recognizes a failure in any form — including screenshots,
# implicit phrasing, and logs that this keyword matcher cannot detect.

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""' | tr '[:upper:]' '[:lower:]')

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Strong match: explicit defect/failure keywords → full diagnosis block
if echo "$PROMPT" | grep -qiE '\b(bug|defect|regress(ion)?|flaky|intermittent)\b|\b(crash|panic|abort|sigkill|oom|segfault)\b|\b(broken|corrupt|stale|stuck|hung|hanging|frozen|deadlock|infinite.loop)\b|\b(404|500|502|503|504|redirect.loop|cors.error)\b|\b(timeout|timed.out|memory.leak|high.cpu)\b|\b(unreachable|not.responding|connection.refused)\b|\b(not.working|doesn.t.work|won.t.start|stopped.working|blank.page|white.screen)\b'; then
  source "$SCRIPT_DIR/trace-helper.sh"
  trace_log "bug-diagnosis" "defect keywords detected"
  cat <<'DIAG'
============================================
BUG/FAILURE DETECTED — RUN /diagnose FIRST
============================================

The user's message describes a bug, error, or failure.
Run the /diagnose skill BEFORE making ANY code changes.

Do not Edit, Write, or run fix commands until you have written:
1. Is / Is Not
2. Five Whys
3. Hypothesis + Test

If this is actually a design discussion (not a bug), state that
and proceed normally.
============================================
DIAG
  exit 0
fi

# Weak match: phrases that often accompany failures — lighter reminder
if echo "$PROMPT" | grep -qiE '(fix|re-run|re.run|how do we|throws|error|issue|wrong|problem|diagnose|screenshot|logs show|FAIL)'; then
  cat <<'REMIND'
============================================
POSSIBLE FAILURE — CHECK BEFORE FIXING
============================================

This message may describe a failure (screenshot, log, or implicit).
The hook cannot always detect failures — YOU must judge:

- Is the user reporting something that isn't working as expected?
- Are they showing a screenshot with errors or unexpected output?
- Are they asking "how do we fix/re-run X"?

If YES → run /diagnose BEFORE writing any fix.
If NO → proceed normally.
============================================
REMIND
fi

exit 0
