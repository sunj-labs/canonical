---
name: SDLC Checkpoint
description: "SDLC gate reference — checklist used by pre-build-gate hook. Not invoked directly; read by hook and agent."
user_invocable: false
disable_model_invocation: false
---

# SDLC Checkpoint — Reference

This checklist is enforced by the **pre-build-gate.sh** hook on every Edit/Write.
It is not invoked as a slash command. The hook fires automatically and references
this checklist.

If you need to run the checklist manually (e.g., hook unavailable), follow these steps:

## Checklist

### 1. Canvas exists?
Is there a canvas in `strategy/canvases/` (or `docs/strategy/`) for this initiative?
- If **no** and scope is non-trivial: **BLOCK**. Run `/canvas` first.
- If scope is trivial (config change, typo fix): skip.

### 2. Spec exists?
Is there a structured spec with acceptance criteria?
- If **no** and scope is non-trivial: **WARN**. Run `/spec` first.
- If scope is trivial: skip.

### 3. Issue exists?
Is there a GitHub Issue tracking this work?
- If **no**: **WARN**. Create one for traceability. Every branch ties to an issue.

### 4. Design artifacts?
For UI changes: do UX translation artifacts exist?
- If touching UI and no design artifacts: **WARN**. Run the UX chain:
  `/jtbd-tasks` → `/task-scenarios` → `/ia-model` → `/interaction-design`

### 5. Branch created?
Is work happening on a feature branch, not main?
- If on main: **BLOCK**. Create a branch: `feature/ISSUE-NNN-short-description`

## Output

```
SDLC Checkpoint
  1. Canvas:    [PASS|FAIL|SKIP] — {detail}
  2. Spec:      [PASS|WARN|SKIP] — {detail}
  3. Issue:     [PASS|WARN]      — {detail}
  4. UX Design: [PASS|WARN|SKIP] — {detail}
  5. Branch:    [PASS|FAIL]      — {detail}
```

If any **BLOCK**: refuse to proceed until resolved.
If any **WARN**: note the risk and ask the user whether to proceed or fix first.
