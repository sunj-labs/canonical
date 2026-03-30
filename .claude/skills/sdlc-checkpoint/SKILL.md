---
name: SDLC Checkpoint
description: Pre-build gate — verifies the SDLC flow was followed before implementation starts
triggers:
  - "start implementing"
  - "begin coding"
  - "write the code"
  - "build this"
  - "implement this"
  - "let's code"
---

# SDLC Checkpoint

Before writing implementation code, verify the SDLC flow was followed.

## Checklist

### 1. Canvas exists?
Is there a canvas in `strategy/canvases/` for this initiative?
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
- If touching UI and no design artifacts: **WARN**. The standard requires JTBD → HTA → State Diagrams → Sequence Diagrams for user-facing surfaces. See `strategy/sdlc-process.md` UX Translation Chain section.

### 5. Branch created?
Is work happening on a feature branch, not main?
- If on main: **BLOCK**. Create a branch: `feature/ISSUE-NNN-short-description`

## Output

Print the checklist with pass/fail/skip for each item:

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
