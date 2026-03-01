# ADR-004: Frontend Stack — Next.js + TypeScript + Tailwind + shadcn/ui

## Status
ACCEPTED

## Date
2026-02-28

## Context
When frontends are needed (deal dashboard, TwoDo, future tools), we need a standard stack that produces consistent, maintainable results — especially when generating UI with AI assistance.

## Decision
Next.js 14+ (App Router) + TypeScript + Tailwind CSS + shadcn/ui.

Deploy via GitHub Pages (static export prototypes) or Docker on EC2 (production with backend integration).

## Rationale

**Next.js:** Static, server-rendered, and API routes in one framework. Anthropic built claude.ai on Next.js — AI code generation quality is highest here.

**TypeScript:** Type safety for real-money decisions. Catches errors at compile time.

**Tailwind CSS:** Maps 1:1 to design tokens (`--color-accent` → `text-blue-600`). Utility-first means no CSS architecture debates.

**shadcn/ui:** Components you copy into your project, not a dependency that updates and breaks. Own everything, customize freely.

**GitHub Pages for prototypes:** Free, zero-config, deploys from the same repo via Actions. Static export only — no API routes, no SSR. Perfect for validating UI with mock data.

**Docker on EC2 for production:** Already running the full stack (OpenClaw, Langfuse, Postgres). No new vendor, no new auth, no new billing surface. Tailscale handles access.

## Alternatives Considered

| Alternative | Rejected Because |
|-------------|-----------------|
| Plain React/Vite | No routing, no SSR, no API routes — you'd rebuild Next.js |
| Vue/Svelte | Great frameworks, worse AI generation quality (smaller training corpus) |
| Streamlit/Gradio | Ugly, non-customizable, violates design principles |
| HTMX | Cool pattern, weak AI code generation support |
| Vercel | Adds a vendor, auth context, and billing surface for something EC2 already does. Revisit only if edge CDN needed for external users at scale. |

## Consequences

### Positive
- Consistent stack across all frontends
- AI-assisted generation produces higher quality output
- Design tokens integrate directly via Tailwind config
- shadcn/ui components are owned, not dependencies
- Two-tier deploy model uses only existing infrastructure

### Negative
- Next.js has a learning curve (App Router patterns)
- GitHub Pages static export loses SSR/API routes (acceptable for prototypes)
- TypeScript adds compile step overhead
