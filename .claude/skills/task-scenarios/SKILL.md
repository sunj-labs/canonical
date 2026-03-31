---
name: task-scenarios
description: Convert task analysis into user stories/scenarios with JTBD traceability. Second step in the UX translation chain.
user_invocable: true
disable_model_invocation: false
---

# Task Analysis → User Stories / Scenarios

Convert HTA/CTA task flows into user stories that trace back to JTBDs.

## When to Use

- After running `/jtbd-tasks` — task flows exist but not yet stories
- When writing stories and need to verify they connect to real jobs
- When reviewing a backlog and stories feel disconnected from user intent
- **The discipline**: every story must trace to a JTBD. If it can't, question whether it belongs.

## Method

### 1. Map Tasks to Stories

```markdown
### Story: [imperative title]

**As a** [persona],
**I want to** [task from HTA],
**So that** [goal from JTBD].

**Job trace**: JTBD #N → Goal M → Task M.X
**CTA decisions**: [what judgment does the user make? what cues do they need?]

**Acceptance criteria**:
- [ ] [observable behavior]
- [ ] [edge case from CTA decision points]
```

### 2. Scenario Writing

For judgment-heavy tasks (CTA), write scenarios that capture the decision context:

```markdown
### Scenario: [descriptive name]

**Given** [context — what state is the user in?],
**When** [trigger — what do they do?],
**Then** [outcome — what should happen?].

**Variant**: [what if the decision goes the other way?]
```

### 3. Traceability Matrix

```markdown
| Story | JTBD | HTA Task | CTA Decision | Priority |
|-------|------|----------|-------------|----------|
| ... | ... | ... | ... | ... |
```

**Red flag**: A story with no JTBD trace is a solution looking for a problem.
**Red flag**: A JTBD with no stories is an unserved user need.

## Anti-Patterns

- Writing stories from features instead of jobs ("add a sidebar" — why?)
- Skipping task analysis and jumping from JTBD to stories (loses the "how")
- Stories that describe implementation, not behavior
- Acceptance criteria that test code, not user outcomes

## Next Step

Stories feed into `/ia-model` (entity inventory + navigation structure).

## References

- Mike Cohn, *User Stories Applied*
- Jim Kalbach, *The Jobs to Be Done Playbook*
