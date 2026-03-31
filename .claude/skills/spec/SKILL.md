---
name: spec
description: Generate structured spec from canvas or issue — bridge product thinking to engineering work.
user_invocable: true
disable_model_invocation: false
---

# Spec — Generate Structured Spec from Canvas or Issue

Bridge the gap between product thinking (canvases) and engineering work (GitHub Issues).

## Input

The user provides either:
- A canvas filename from `strategy/canvases/`
- A GitHub Issue number
- A verbal description of what needs to be specified

## Steps

1. Read the source material (canvas, issue, or user description)
2. Read `strategy/templates/spec-template.md` for the format
3. Read `design/object-model.md` to understand existing domain objects
4. Generate a structured spec:

```markdown
# Spec: {Feature Name}

## Context
Link to canvas or issue. Why this exists.

## Requirements

### Must Have
- [ ] Requirement — Acceptance: {specific testable condition}

### Should Have
- [ ] ...

### Won't Have (this round)
- ...

## Design
- User flow (step by step)
- Object model impact (new objects, changed objects)
- Interface contract (API shape, component props)

## Technical Approach
- Key files to create or modify
- Dependencies on existing code
- Migration needs

## Open Questions
- Anything needing human decision before building
```

## Output

Write to `specs/{YYYY-MM-DD}-{slug}.md` (or `docs/specs/` in app repos)

## Rules

- Every Must Have needs at least one testable acceptance criterion
- Not "works correctly" but "returns HTTP 200 with JSON body containing dealId"
- If source is too vague, list what questions need answering — don't invent requirements
- Reference existing objects from the object model; flag when new objects are needed
- When UI is involved, note that UX translation chain is needed
