# Frontend Stack Standard

## Decision

Next.js + TypeScript + Tailwind CSS + shadcn/ui

See [ADR-004](../architecture/decisions/ADR-004-frontend-stack.md) for rationale.

## Stack

```
Next.js 14+ (App Router)
├── TypeScript         — type safety for real-money decisions
├── Tailwind CSS       — design tokens map directly to utilities
├── shadcn/ui          — copy-paste components you own and customize
└── Deploy via:
    ├── GitHub Pages    — static export, prototypes, zero cost
    └── Docker on EC2   — production, backend integration, Tailscale mesh
```

## Deployment Tiers

See [ADR-005](../architecture/decisions/ADR-005-frontend-deploy-tiers.md) for rationale.

| Tier | When | Where | Cost |
|------|------|-------|------|
| **Mockup** | Exploring layout, rapid iteration, disposable | Claude artifacts, local dev, single HTML file | $0 |
| **Prototype** | Shareable link, multi-page flows, mock data | GitHub Pages (`output: 'export'`) | $0 |
| **Production** | Real data, persistent state, backend integration | Docker on EC2 via Tailscale | $0 marginal |

Start every frontend at Tier 0 (mockup). Graduate only when the current tier blocks progress.

## Conventions

- Components live in `/src/components/ui/` (shadcn/ui, modified to use design tokens).
- Pages use App Router conventions (`/app/page.tsx`, `/app/layout.tsx`).
- Design tokens from `platform-docs/design/design-tokens.css` map to Tailwind config.
- No external component libraries beyond shadcn/ui. You own every component.
- GitHub Pages deploys require `output: 'export'` in `next.config.js` and a `.nojekyll` file.

## When to Build a Frontend vs. Stay CLI

| Frontend | CLI |
|----------|-----|
| Non-technical users (TwoDo) | Tools OpenClaw calls |
| Visual data density (deal dashboard) | Developer workflows |
| Shareable with someone who won't open a terminal | Automation scripts |
