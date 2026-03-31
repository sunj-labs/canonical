#!/bin/bash
set -e

# Tool Failure Diagnosis — fires on PostToolUse.
# When a tool returns an error or failure signal, inject the
# temperance → diagnose chain before Claude retries.

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
OUTPUT=$(echo "$INPUT" | jq -r '.tool_output // ""' | head -20)

# Check if the tool output contains failure signals
if echo "$OUTPUT" | grep -qiE '(error|Error|ERROR|fail|FAIL|exit code [1-9]|ENOENT|EACCES|EPERM|denied|refused|404|500|502|503|504|panic|fatal|FATAL|exception|Exception|timed.out|no space|cannot|Could not|not found|Not Found|unhandled|Unhandled)'; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  source "$SCRIPT_DIR/trace-helper.sh"
  trace_log "tool-error" "$TOOL_NAME failed"
  cat <<'DIAG'
============================================
TOOL ERROR — TEMPERANCE → DIAGNOSE
============================================

A tool call just returned an error. Follow this chain:

1. TEMPERANCE (pause before reacting)
- Am I about to brute-force a retry with different args?
- What is the SIMPLEST correct next step?
- If I don't know WHY it failed, the answer is ALWAYS "understand first."

2. DIAGNOSE (understand before fixing)
- What failed: [tool, command, expected vs actual]
- Is / Is Not: [what's broken vs what still works]
- Why (quick trace): [1-3 whys to likely root cause]
- Hypothesis: [what you think caused it]
- Next step: [a READ-ONLY diagnostic command, NOT a fix]

3. THEN FIX (only after diagnosis is written)

For simple, expected errors (e.g., "file not found" when checking if
something exists), state "Expected error — [reason]" and proceed.

For unexpected errors: do NOT retry, do NOT guess different args,
do NOT work around silently. Diagnose first.
============================================
DIAG
fi

exit 0
