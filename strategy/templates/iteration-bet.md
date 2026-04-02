# Iteration Bet Template

Every iteration must declare its bet before work begins. This is a required
substrate artifact — the Orchestrator will not schedule an iteration without it.

```markdown
## Iteration N Bet

**Phase**: Inception / Elaboration / Construction / Transition
**Appetite**: X days

**Risk being retired**:
- R-XXX: [description] — how this iteration resolves it

**Business value being proven**:
- [Outcome]: [how we'll know we proved it]

**Lovability signal**:
- [What the Designer is validating this iteration]

**Viability signal**:
- [What the PM is watching — metric, user behavior, or decision gate]

**Balance rationale**: [1-2 sentences on why this mix of risk vs. value is right for where we are]
```

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
