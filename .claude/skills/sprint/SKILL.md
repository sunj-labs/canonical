---
name: sprint
description: "Show current iteration bet, open issues by priority, and proposed next sprint. Quick orientation for any session."
user_invocable: true
disable_model_invocation: false
---

# Sprint — Current State + Next Work

Quick orientation skill. Shows where we are and what's next.
Run at the start of any session or when you need to re-orient.

## Procedure

### 1. Read current iteration bet

Check `docs/iteration-bets/` for the most recent bet file. Show:
- Iteration name, phase, subsystem
- Primary luminary (if set)
- Appetite remaining
- Status: active / complete / abandoned

If no iteration bet exists, say so and suggest `/autonomous start`.

### 2. Show open issues by tier

Read open GitHub issues and categorize:

```bash
gh issue list --state open --json number,title,labels --limit 30
```

Present in priority tiers:

**Tier 1 — Must-fix** (blocks next autonomous run or causes failures):
[list issues that affect reliability, safety, or correctness]

**Tier 2 — Should-fix** (improves experience, reduces friction):
[list UX, polish, and enhancement issues]

**Tier 3 — Strategic** (larger scope, next cycle):
[list research, new capabilities, architectural work]

### 3. Propose next sprint

Based on the tier 1 issues and the current state, propose:
- **Sprint name**: short descriptive name
- **Scope**: which issues, in what order
- **Appetite**: recommended cost ceiling + turn limit
- **Phase**: what phase this work is in
- **Primary luminary**: if relevant

### 4. Show session context

- Commits since last chronicle
- Stale artifacts (chronicles, LinkedIn, architect reviews)
- Phase-state summary (if `docs/phase-state.md` exists)

## Output format

```
## Sprint Status

### Current iteration
[name] — [status]
Phase: [phase] | Subsystem: [subsystem]
Primary luminary: [name or "none"]
Appetite: [remaining] of [total]

### Open issues (N total)

**Tier 1 — Must-fix (N)**
- #NN — title
- #NN — title

**Tier 2 — Should-fix (N)**
- #NN — title

**Tier 3 — Strategic (N)**
- #NN — title

### Proposed next sprint
Name: [name]
Scope: #NN, #NN, #NN (N issues)
Appetite: $X / N turns
Phase: Construction

### Session context
Last chronicle: YYYY-MM-DD (N commits since)
Stale artifacts: [list or "none"]
```

## Rules

- This is read-only — never modify files or create issues
- Always check GitHub for current issue state (don't rely on memory)
- Tier classification is based on impact, not label
- If the operator wants to start the proposed sprint, suggest `/autonomous start`
