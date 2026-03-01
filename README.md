# platform-docs

Strategy, design system, architecture decisions, and engineering standards for [sunj-labs](https://github.com/sunj-labs).

## Structure

```
platform-docs/
├── strategy/
│   ├── sdlc-process.md          ← Full SDLC strategy document
│   ├── templates/
│   │   ├── product-canvas.md
│   │   ├── pr-faq.md
│   │   └── spec-template.md
│   └── canvases/                ← Filled-in canvases per initiative
├── design/
│   ├── design-principles.md     ← The Seven Rules
│   ├── design-tokens.css        ← CSS custom properties
│   ├── object-model.md          ← Shared object definitions
│   ├── component-patterns.md    ← Card, table, status, CLI, Telegram
│   └── ai-design-guidelines.md  ← NNG-informed AI UX rules
├── architecture/
│   └── decisions/               ← ADRs
│       ├── template.md
│       ├── ADR-001-github-as-idp.md
│       ├── ADR-002-langfuse-observability.md
│       ├── ADR-003-titans-deferred.md
│       └── ADR-004-frontend-stack.md
├── standards/
│   ├── branching-strategy.md
│   ├── commit-conventions.md
│   ├── frontend-stack.md
│   ├── security-scanning.md
│   └── testing-requirements.md
└── runbooks/                    ← Added as ops patterns emerge
```

## How to Use

This repo is reference material, not running code. It's the source of truth for how sunj-labs builds things.

Before writing a spec, check the **templates**. Before making a design decision, check the **principles**. Before adding a new object to any repo, check the **object model**. Before choosing a technology, check for an existing **ADR**.

## SDLC Flow

```
Canvas → PR/FAQ → Issue → Spec → Branch → PR → CI → Deploy → Observe
```
