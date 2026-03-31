---
name: jtbd-tasks
description: Translate Jobs-to-be-Done into task analysis — HTA trees + CTA decision points. First step in the UX translation chain.
user_invocable: true
disable_model_invocation: false
---

# JTBD → Task Analysis

Translate job statements into concrete task flows. First layer in the
JTBD → HTA → IA → State Diagram translation chain.

## When to Use

- During the **Design phase** of the SDLC, concurrent with design diagrams
- A new feature or initiative enters the Design phase
- The user describes what they want to accomplish (a "job")
- Requirements feel vague — decompose into actionable tasks
- Before writing user stories — stories trace to tasks, tasks trace to jobs
- UX fitness review flags stale task analysis

## Method 1: Hierarchical Task Analysis (HTA)

For **sequential, procedural work** — steps that follow a predictable order.

Break each job into: **Goal → Plan → Subtasks → Operations**

```
JOB: [job statement]

GOAL 1: [goal]
  PLAN: [strategy for achieving goal]
  1.1 [subtask]
  1.2 [subtask]
  1.3 [subtask]

GOAL 2: [goal]
  PLAN: [strategy]
  2.1 [subtask]
  ...
```

## Method 2: Cognitive Task Analysis (CTA)

For **judgment-heavy work** — where expertise drives decisions, not just steps.

Add to the HTA: **decision points, mental models, and expertise cues**

```
GOAL 2: [goal]
  DECISION: [what judgment is needed?]
    CUES: [what information triggers the decision?]
    MENTAL MODEL: [what expertise is applied?]
    EXPERTISE: [what do experienced users look at first?]
```

## Output Format

For each JTBD, produce:

```markdown
## Job: [job statement]

### HTA Tree
- Goal 1: [goal]
  - 1.1 [subtask]
  - 1.2 [subtask] → DECISION: [what judgment?]
    - Cues: [what triggers the decision?]
    - Mental model: [what expertise?]
  - 1.3 [subtask]
- Goal 2: ...

### Task Flow Diagram (Mermaid)
[flowchart showing sequential + branching task flow]

### Traceability
| Task | JTBD | UI Implication |
|------|------|----------------|
| 1.1 ... | [job] | [screen or component implied] |
```

## Next Step

Output feeds into `/task-scenarios` (user stories) or directly into `/ia-model` (entity-driven IA).

## References

- Alan Cooper, *About Face* — Goal-Directed Design
- Don Norman, *The Design of Everyday Things* — task analysis foundations
- Annett & Duncan (1967) — original HTA methodology
