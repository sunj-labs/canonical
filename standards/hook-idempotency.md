# Hook Idempotency Standard

## Principle

Hooks must be idempotent. If a hook fails partway and reruns, it must
not duplicate work, generate false warnings, or corrupt state.

## Rules

### 1. No write-then-detect

A hook must not write state and then check for that state in the same
execution. The classic violation:

```bash
# BAD: writes SESSION_LOCK, then detects it and warns "another session active"
echo "$(date)" > .claude/SESSION_LOCK
if [ -f .claude/SESSION_LOCK ]; then
  echo "WARNING: another session may be active"
fi
```

Fix: check BEFORE writing, or use a lock acquisition pattern:

```bash
# GOOD: check first, then write
if [ -f .claude/SESSION_LOCK ]; then
  echo "WARNING: another session may be active"
else
  echo "$(date)" > .claude/SESSION_LOCK
fi
```

### 2. Append with dedup

Hooks that append to files (trace logs, artifact lists) must check
whether the content already exists:

```bash
# BAD: appends every run, creating duplicates on retry
echo "gate: temperance" >> docs/sdlc-traces/today.log

# GOOD: check before appending
grep -q "gate: temperance" docs/sdlc-traces/today.log 2>/dev/null || \
  echo "gate: temperance" >> docs/sdlc-traces/today.log
```

### 3. Create-if-missing, not create-always

```bash
# BAD: overwrites existing file on every run
echo "# Risk Register" > docs/risk-register.md

# GOOD: only create if missing
[ -f docs/risk-register.md ] || echo "# Risk Register" > docs/risk-register.md
```

### 4. Exit codes are meaningful

- Exit 0: hook succeeded, continue
- Exit non-zero: hook failed, behavior depends on hook type
  - PreToolUse hooks: non-zero blocks the tool call
  - PostToolUse/Stop hooks: non-zero is logged but doesn't block

Never swallow errors silently:

```bash
# BAD: hides failures
some_command 2>/dev/null || true

# GOOD: log the failure, then decide whether to continue
some_command 2>&1 || echo "WARNING: some_command failed (non-blocking)"
```

### 5. Timeout awareness

Stop hooks have limited execution time. If your Stop hook does
network operations (git push, API calls), put them AFTER local
operations so that local artifacts are saved even if the hook times out.

```bash
# Phase 1: Local (always completes)
write_chronicle
update_memory
remove_session_lock

# Phase 2: Remote (may timeout — that's OK)
git push || echo "WARNING: push failed — run manually"
push_to_gdoc || echo "WARNING: Google Doc push skipped"
```

Minimum recommended Stop hook timeout: 30 seconds.

## Verification

The `/self-test` skill includes a hook idempotency spot-check (step 8)
that scans for common violations of these rules.
