# Iteration Bet Template

Every iteration must declare its bet before work begins. At `standard` and
`full` levels, the Orchestrator will not schedule an iteration without it.
At `core` level, use the light format at the bottom.

## Full Format (standard + full levels)

```markdown
## Iteration N Bet

**Phase**: Elaboration / Construction / Transition

**Scope**:
- [Feature / ADR / spec section being built — the work definition]

**Risk being retired**:
- R-XXX: [description] — how this iteration resolves it

**Business value being proven**:
- [Outcome]: [how we'll know we proved it]

**Lovability signal**:
- [What the Designer is validating this iteration]

**Viability signal**:
- [What the PM is watching — metric, user behavior, or decision gate]

**Appetite**:
- Cost ceiling: $X (from manifest — Orchestrator will not schedule without this)
- Turn limit: N (runaway loop protection)
- Warning threshold: 75% of cost ceiling — Orchestrator surfaces status

**Balance rationale**: [1–2 sentences on why this mix is right for where we are]
```

## Light Format (core level)

```markdown
## Iteration N
Retiring: R-001 [one line]
Proving: [one line — what business signal]
Scope: [features / ADRs / spec sections]
Cost ceiling: $X
Turn limit: N
```

Three to five lines. Same forcing function. No ceremony.

## Balance heuristics by phase

| Phase | Risk weight | Value weight | Rationale |
|---|---|---|---|
| Inception | 80% | 20% | Kill bad ideas before building them |
| Elaboration | 60% | 40% | Prove architecture while signaling early value |
| Construction | 40% | 60% | Build toward value; residual risk management |
| Transition | 20% | 80% | Ship. Stabilize. Prove it works in the wild. |

## Evaluation (post-iteration)

After the iteration, evaluate against the Lean Product Triangle:
- **Viable** (PM): Did this move a business metric or prove a model assumption?
- **Lovable** (Designer): Would a user choose this over doing nothing?
- **Feasible** (Architect + Builder): Can we build and maintain this sustainably?

Two out of three is acceptable early. All three by Transition.
