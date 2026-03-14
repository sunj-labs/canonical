# SDLC Flow

## Philosophy

Build less. Ship what matters. Measure outcomes, not output.

Every initiative runs through the same lightweight process. The process exists to force clarity before code, not to create ceremony.

## Lifecycle

Each step drives increasing certainty in what to engineer.

```
Interview (open-ended discovery — why does this matter?)
  → Canvas: Thesis (5 min — what's the bet?)
    → Canvas: Shape (30 min — what's the value?)
      → Canvas: Commit (PR/FAQ, if scope warrants)
        → Design (structure + behavior — how does it work?)
          → Specs (what to build — requirements, acceptance criteria)
            → Spec Review (PR or doc review)
              → Epics / User Stories (work items in GitHub)
                → Implementation (feature branch)
                  → Code Review (PR)
                    → CI (automated pipeline)
                      → Deploy
                        → Observe
                          → Retrospect (decision record if architectural)
```

### Design Step

Between Canvas/PR-FAQ and Specs, produce design diagrams that reduce
ambiguity about structure and behavior. All diagrams use Mermaid and
live in `docs/design/`.

| Diagram | Shows | When it earns its keep |
|---------|-------|----------------------|
| **ERD** (from Prisma schema) | Entity relationships, cardinality | Always — if you have a schema, render it |
| **Use Case** | Actor/action authorization boundaries | When multiple roles interact differently |
| **Component** | System components + external services | When there are async workers, queues, or external APIs |
| **Deployment** | Infrastructure layout, ports, networking | When deploying alongside other services |
| **Sequence** | Async flows, event chains, handoffs | When there are queues, agents, or multi-step automations |
| **Activity** | Branching logic, decision trees | When a pipeline has conditional paths |
| **State** | Object lifecycle transitions | When an entity has a status workflow |

### State Diagrams in Agentic Systems

State diagrams are **first-class** in any system with autonomous agents.
They define the **contract** between agents and the objects they act on:

- **Which transitions each agent is allowed to make.** The Scorer can
  transition NEW → SCORED but not SCORED → SHORTLISTED. Without this,
  agents do whatever they want.
- **Which transitions require human approval.** Any transition past SCORED
  needs an OPERATOR. The state diagram makes the automation boundary explicit.
- **What the valid recovery paths are.** Can a REJECTED deal be reconsidered?
  The state diagram answers this, not the code.

For agentic systems, produce a state diagram for every entity that:
1. Has a status/lifecycle enum
2. Is acted on by autonomous agents
3. Has transitions that require different authorization levels

These diagrams are not documentation — they are **specifications** that the
agent implementation must enforce.

Not every initiative needs all seven diagram types. Use the table to decide:
- **Operator scope, simple**: ERD + maybe a sequence. Skip the rest.
- **Operator scope, agentic/async**: ERD + Component + Sequence + Activity + State (required).
- **Domain/Product scope**: All that apply.

### Object Model

New objects introduced by any initiative must be registered in the
shared object model (`platform-docs/design/object-model.md`) before
specs are written. This prevents naming drift across repos.

## Rules

1. Nothing gets built without a work item.
2. No work item over size M ships without a spec.
3. Specs are reviewed before code starts.
4. Design diagrams are produced before specs for any initiative with async flows or multiple components.
5. Every merge to main is deployable.
6. Outcomes are measured, not just shipped.

## Cadence

For solo operators or small teams without sprint accountability:

- **Weekly review:** Look at the board. What shipped? What's stuck? What's next?
- **Milestones:** Time-boxed goals. Not deadlines — forcing functions for scope.
- **Decision records:** Written when you make a decision you'll forget in 3 months.

For teams with sprint cadence: map milestones to iterations. The canvas and spec workflow sits upstream of sprint planning.

## Documentation as Byproduct

| Layer | What | When updated |
|-------|------|--------------|
| Decision records | Why decisions were made | When you make a decision |
| Specs | What gets built and why | Before implementation |
| Session logs / stand-ups | What happened | Every session or daily |
| Changelog | What shipped | Every merge to main |
| README | What this is, how to run it | When setup changes |

If you follow the flow, documentation writes itself. If you're writing standalone docs, something is wrong with the process.
