# sunj-labs / platform-docs

## What this repo is

Strategy, design system, architecture decisions, and engineering standards
for sunj-labs. This is the shared methodology — app repos import from here
via `--add-dir`.

This is a documentation repo. There is no application code.

## Structure

- `standards/` — engineering standards (testing, security, commits, branching, diagnosis, usability)
- `strategy/` — SDLC process, session continuity, templates, canvases
- `design/` — design principles, engineering principles, AI guidelines, object model, components
- `architecture/` — system context diagram, ADRs (11 recorded)
- `chronicle/` — dated session records
- `sdlc-portable/` — extractable subset of methodology for any platform

## Conventions

- Conventional commits: `type: description` (feat, fix, docs, refactor, test, ci, chore, security)
- Canvases follow three stages: Thesis → Shape → Build Sequence
- Chronicles use frontmatter: session_id, project, agent, status, tags
- New standards go in `standards/`, not inline in other docs
- Object model changes require updating `design/object-model.md`
- Specs reference their source canvas or issue

## SDLC flow

```
Canvas → Spec → Design → Issue → Branch → PR → CI → Deploy → Observe
```

When a UI surface is impacted, run the UX translation chain during Design:
```
JTBD → HTA → Entity Model → State Diagrams → Sequence Diagrams
```

## Templates

- Product canvas: `strategy/templates/product-canvas.md`
- Spec: `strategy/templates/spec-template.md`
- PR/FAQ: `strategy/templates/pr-faq.md`
- ADR: `architecture/decisions/template.md`

## Key files

- `strategy/sdlc-process.md` — full lifecycle with gates and enforcement
- `strategy/session-continuity.md` — three-layer memory architecture
- `design/object-model.md` — 37 shared domain objects
- `design/engineering-principles.md` — Core Five + Earn Your Keep test
- `design/trust-zone-flow.md` — runtime security sequence
- `standards/frontend-stack.md` — full TypeScript stack (ADR-008)

## Current state

- 7 canvases, 18+ chronicles, 11 ADRs, 7 standards
- Active initiative: multi-agent autonomous SDLC
- POA is the first app repo consuming these standards

## What NOT to do

- Don't create new top-level directories without discussion
- Don't duplicate content between `sdlc-portable/` and `standards/` — pick one source
- Don't write canvases without all three stages (Thesis → Shape → Build)
- Don't skip diagnosis when investigating failures (standards/diagnosis.md)
- Don't add objects to the model without updating `design/object-model.md`
