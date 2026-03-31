---
name: interaction-design
description: IA + task flows → interaction design — state diagrams, sequence diagrams, user flows. Final step in the UX translation chain.
user_invocable: true
disable_model_invocation: false
---

# Interaction Design — State + Sequence + Flows

Translate IA and task flows into formal interaction specifications.
Final layer: JTBD → HTA → IA → **Interaction Design**.

## When to Use

- After `/ia-model` — entity map and screen map exist
- Before building UI — need to specify states, transitions, edge cases
- When a flow feels "off" — formalize it to find the gap
- When handing off to implementation — engineers need state machines, not wireframes

## Method 1: UML State Diagrams

**The most rigorous tool.** Each screen or component mode is a state;
user actions and system events are transitions.

Use when:
- Components with distinct modes (idle → expanded → editing)
- Pages with conditional rendering (loading → empty → populated → filtered)
- Async flows (idle → running → success/error)
- Auth states (anonymous → authenticating → authenticated → expired)

### Edge case checklist
For every state diagram, ask:
- What happens if the user **goes back** (browser back button)?
- What happens if the user **refreshes** in this state?
- What happens if the **session expires** while in this state?
- What happens if **data changes** while the user is viewing it?
- What happens on a **slow connection** (loading states)?
- What happens on **error** (API fails, DB down)?

## Method 2: UML Sequence Diagrams

**Show temporal interaction** between actors: User, UI, Backend, External APIs.

Use when:
- API call chains (auth flows, multi-step wizards)
- Async job flows (trigger → queue → worker → result)
- Data display (page load → server component → DB → render)

## Method 3: User Flows

**Less formal, more communicative.** Good for stakeholder alignment.
Flowcharts showing decision points and paths through the UI.

## Method 4: Service Blueprints

**Extend user flows to include backstage processes.**

```
FRONTSTAGE (user sees):     Browse → Filter → Detail → Act
                                ↕         ↕        ↕
BACKSTAGE (system does):    Score → Index → Enrich → Notify
                                ↕         ↕
SUPPORT PROCESSES:          Ingest → Classify → Deduplicate
```

## Output Format

For each interaction flow:

```markdown
## Flow: [name]

### State Diagram
[Mermaid stateDiagram-v2]

### Sequence Diagram (if async/multi-actor)
[Mermaid sequenceDiagram]

### Edge Cases
- Back button: [behavior]
- Refresh: [behavior]
- Session expiry: [behavior]
- Error: [behavior]
- Slow connection: [behavior]

### Traceability
| State/Transition | HTA Task | JTBD |
|-----------------|----------|------|
| ... | ... | ... |
```

## The Anchoring Standard

The full stack: **JTBD → HTA → UML State Diagrams → UML Sequence Diagrams**,
with IA falling out of entity modeling in between.

## References

- Alan Cooper, *About Face* — Goal-Directed Design
- Craig Larman, *Applying UML and Patterns*
- Don Norman, *The Design of Everyday Things*
- Jenifer Tidwell, *Designing Interfaces*
- Jim Kalbach, *The Jobs to Be Done Playbook*
