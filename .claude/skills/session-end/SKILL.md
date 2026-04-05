---
name: session-end
description: "Explicit session-end protocol with tiered obligations. Use when Stop hook fails, session is ending, or as a manual fallback."
user_invocable: true
disable_model_invocation: false
---

# Session End

Explicit session-end protocol. The Stop hook calls this automatically,
but you can invoke it directly if:
- The hook failed or timed out
- You're ending a session manually
- You want to ensure artifacts are written before a long pause
- Cloud or mobile sessions where hooks may not fire

## Tiered Obligations

Steps are tiered by criticality. **Must** tier completes even if the
session is dying. **Should** and **May** tiers fail gracefully.

### Must (local, no network, always possible)

These steps MUST complete. They require no network and no external
services. If the session can execute any code at all, these should work.

1. **Clean working tree**
   ```
   git status --porcelain
   If dirty: commit with "chore: session-end checkpoint" or stash
   Never leave uncommitted work
   ```

2. **Chronicle entry**
   ```
   Write to the repo's chronicle directory:
   - Check docs/chronicle/, docs/design/chronicle/, chronicle/
   - Use whichever exists; create docs/chronicle/ if none
   - Include: entry state, work done (commit refs), decisions, open threads
   - Verify the file exists after writing
   ```

3. **Memory update**
   ```
   Save anything learned this session that future sessions need:
   - User preferences discovered
   - Project context that changed
   - Feedback received (corrections AND confirmations)
   ```

4. **Remove session lock**
   ```
   rm -f .claude/SESSION_LOCK
   ```

### Should (network needed, may fail)

These steps SHOULD complete but depend on network. If they fail,
log the failure and continue — do NOT let them kill the Must tier.

5. **Git push**
   ```
   git push || echo "WARNING: push failed — run 'git push' manually"
   ```

6. **Update phase-state.md**
   ```
   If docs/phase-state.md exists:
   - Update active agents (clear)
   - Update progress (what's done, what's next)
   - Update cost tracking (turns, duration)
   ```

### May (conditional, environment-dependent)

These steps are valuable but not critical. Skip without guilt if
the environment doesn't support them or if time is short.

7. **Danger mode summary** (if session used auto-complete)
   ```
   Write to docs/danger-mode-summaries/YYYY-MM-DD.md
   What was done autonomously, what decisions were made without
   human confirmation, any risks introduced
   ```

8. **LinkedIn draft** (if session produced something notable)
   ```
   Ask: "Did this session produce a notable decision, trade-off,
   or insight worth sharing?"
   If yes: write to docs/linkedin-drafts/YYYY-MM-DD.md
   If linkedin_doc_id configured in substrate.config.md: push to Google Doc
   ```

9. **Release notes** (if user-facing changes deployed)
   ```
   Write to docs/release-notes/YYYY-MM-DD.md
   Plain language for the least technical stakeholder
   ```

## Execution Order

```
MUST tier (always runs, no network needed):
  1. Clean working tree
  2. Chronicle entry
  3. Memory update
  4. Remove session lock
  ── if any Must step fails: log error, continue to next Must step ──

SHOULD tier (network needed, graceful failure):
  5. Git push
  6. Update phase-state.md
  ── if any Should step fails: warn, continue ──

MAY tier (conditional):
  7. Danger mode summary (if applicable)
  8. LinkedIn draft (if notable)
  9. Release notes (if deployed)
  ── if any May step fails: skip silently ──
```

## Hook Integration

The Stop hook should call this skill as its primary action:

```bash
#!/bin/bash
# .claude/hooks/session-end.sh
# Minimum timeout: 30 seconds (see standards/hook-idempotency.md)

# Phase 1: Local artifacts (Must tier — always runs)
# The skill handles this, but if the skill fails to load,
# at minimum do:
#   - git add -A && git commit -m "chore: auto-save" || true
#   - rm -f .claude/SESSION_LOCK

# Phase 2: The skill handles Should and May tiers
# These can timeout without losing Must tier artifacts
```

If the Stop hook times out before completing, the Must tier artifacts
(commit, chronicle, lock cleanup) should already be written because
they execute first with no network dependency.

## Timeout Guidance

- Minimum Stop hook timeout: **30 seconds**
- Must tier target: complete in < 10 seconds
- Should tier target: complete in < 15 seconds
- May tier target: best-effort in remaining time
- If total exceeds 30 seconds: Must tier is already done, so timeout
  only loses Should/May artifacts (recoverable next session)

## Rules

- Must tier steps NEVER depend on network
- Must tier steps NEVER depend on external services (Google Docs, etc.)
- Each tier runs independently — a failure in Should doesn't skip May
- Log all failures visibly — don't swallow with `2>/dev/null || true`
- If invoked manually, report what was completed and what was skipped
