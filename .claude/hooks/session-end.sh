#!/bin/bash
set -e

# Session End hook — fires on Stop event.
# Requires Claude to run session-end protocol.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/trace-helper.sh"
trace_log "session-end" "stop event"

cat <<'END'
============================================
SESSION END — MANDATORY WRAP-UP
============================================

Before ending, your response MUST include:

## Session Wrap-Up

1. **Uncommitted work**: Is the working tree clean? Commit or stash.
2. **Board status**: Update issues to Done/In Progress as appropriate.
3. **Memory**: Save anything learned this session for next time.
4. **Chronicle entry**: Write to chronicle/ (or docs/chronicle/)
   - What shipped (with commit refs)
   - What was learned
   - Open threads for next session
   - This is NOT optional.
5. **SDLC trace**: hooks log automatically, but verify traces exist.
6. **Danger mode summary**: If auto-complete was used, write the audit trail
   to docs/danger-mode-summaries/YYYY-MM-DD.md
7. **LinkedIn draft**: If something worth sharing shipped, draft a post
   to docs/linkedin-drafts/YYYY-MM-DD.md (or configured Google Doc)
8. **Release notes**: If user-facing changes deployed:
   - Draft to docs/release-notes/YYYY-MM-DD.md
   - Plain language for the least technical user
9. **Session lock**: Remove .claude/SESSION_LOCK if it exists.
10. **Next session**: 1-2 sentences on what to pick up next.

Do NOT skip the chronicle. Do NOT say "I'll write it next time."
Write it now or the session-start hook will flag it.
============================================
END

exit 0
