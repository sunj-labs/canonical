---
name: diagnose
description: Structured defect diagnosis — Is/Is Not, Five Whys, Hypothesis. Run BEFORE fixing any bug.
user_invocable: true
disable_model_invocation: false
---

# Diagnose

Structured defect diagnosis. Run this BEFORE writing any fix code.

## When to Use

Any time something is wrong, broken, failing, or behaving unexpectedly. Trigger words:
- **Defects**: bug, defect, regression, flaky, intermittent
- **Failures**: error, fail, crash, panic, exception, abort, SIGKILL, OOM
- **State**: broken, wrong, corrupt, stale, stuck, hung, hanging, frozen, deadlock
- **HTTP**: 404, 500, 502, 503, 504, redirect loop, CORS
- **Performance**: timeout, timed out, slow, degraded, memory leak, high CPU
- **Availability**: down, dead, unreachable, not responding, connection refused
- **Behavior**: not working, doesn't work, won't start, stopped working, blank page, spinner

## Procedure

### Step 1: Gather Evidence (READ-ONLY — no code changes)

Before writing ANY fix, run diagnostic commands:
- `git log --oneline -10` — what changed recently?
- Check logs (application, worker, CI output)
- Check health endpoints
- Check browser console errors (ask user for screenshot if needed)

### Step 2: Is / Is Not

Write this section VISIBLY in your response:

```
## Is / Is Not
- **IS**: [what exactly fails — URLs, status codes, error messages]
- **IS NOT**: [what still works — narrow the blast radius]
- **Changed**: [what changed recently — commits, deploys, config, external services]
```

### Step 3: Five Whys

Trace to root cause. Don't stop at the symptom.

```
## Five Whys
1. Why does [symptom]? → because [X]
2. Why [X]? → because [Y]
3. Why [Y]? → because [Z]
4. Why [Z]? → because [W]
5. Why [W]? → ROOT CAUSE: [...]
```

### Step 4: Hypothesis + Test

State what you think caused it, and how you'll verify BEFORE writing a fix:

```
## Hypothesis
- **Cause**: [your theory]
- **Test**: [a read-only command to verify — NOT a fix]
- **If confirmed**: [what you'll change]
```

### Step 5: Significance Check

Before fixing, classify the finding:

```
## Significance
- **Level**: [trivial / moderate / significant]
- **Criteria**: [< 30 min + no new objects + no UI change = trivial]
- **UI surface impacted?**: [yes/no — if yes, UX translation may be needed]
- **Epic required?**: [trivial = no (log in commit), moderate+ = yes]
```

If **moderate or significant**: create a GitHub issue BEFORE writing fix code.

If **trivial**: proceed to fix, log "Found X, assessed as trivial because Y" in the commit message.

### Step 6: Fix

Only NOW may you write code. The fix should address the ROOT CAUSE, not the symptom.

## Anti-patterns

- Guessing-and-retrying with different parameters
- Silently working around an error instead of understanding it
- Fixing the symptom without tracing to root cause
- Skipping diagnosis because "it's obvious" — it's usually not
