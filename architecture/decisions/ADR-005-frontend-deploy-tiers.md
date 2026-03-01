# ADR-005: Frontend Deployment Tiers — Constraint-Based

## Status
ACCEPTED

## Date
2026-02-28

## Context
"Necessity is the mother of invention." Bezos underfunded teams on purpose. Anthropic's Catherine Wu advises the same. The principle: constrain resources to force creative solutions and prevent premature complexity.

Applied to frontend deployment: we don't need a third-party hosting vendor when we already run Docker on EC2 with Tailscale. We don't need production infrastructure when we're validating a UI concept. We don't need a repo when we're sketching a layout.

Start with the cheapest thing that works. Graduate only when the constraint blocks real progress.

## Decision

Three tiers. Each earns its complexity.

### Tier 0: Mockup — Ephemeral, No Infrastructure

- **What:** Single-file React artifacts (Claude chat), standalone HTML files, or local dev server
- **When:** Exploring layout, validating component patterns, testing interaction flows, rapid iteration
- **Where:** Claude chat artifacts, local browser, or `npx next dev` on your machine
- **Cost:** $0, zero setup
- **State:** In-memory (`useState`, JS variables, hardcoded JSON fixtures)
- **Lifespan:** Disposable. The mockup is a conversation, not a deliverable. When you're happy, it becomes the reference spec for the real build.
- **Routing:** Not needed (single-page) or client-side only
- **Who sees it:** You

### Tier 1: Prototype — Shareable, GitHub Pages

- **What:** Next.js static export (`output: 'export'` in `next.config.js`)
- **When:** You need a persistent, linkable URL. Sharing a concept with someone. Validating multi-page flows with client-side routing. Mock data, no backend.
- **Where:** GitHub Pages, deployed via GitHub Actions from the repo
- **Cost:** $0
- **State:** Mock JSON fixtures, client-side state. No database, no server-side secrets.
- **Lifespan:** Lives as long as the repo branch. Can be torn down or overwritten.
- **Routing:** Client-side routing works (`<Link>`, `useRouter`). No API routes, no SSR, no middleware.
- **Who sees it:** Anyone with the link
- **Config requirements:** `output: 'export'`, `.nojekyll` file, `basePath` set to repo name

### Tier 2: Production — Docker on EC2

- **What:** Full Next.js with SSR, API routes, database access, backend colocation
- **When:** Real data, persistent state, server-side secrets, backend integration
- **Where:** Docker container on EC2 (us-east-1), accessed via Tailscale mesh
- **Cost:** $0 marginal (EC2 already running)
- **State:** Postgres, filesystem, any backend service
- **Lifespan:** Permanent until decommissioned
- **Routing:** Full Next.js capabilities — SSR, API routes, middleware, server actions
- **Who sees it:** Tailscale mesh (internal) or public if explicitly exposed
- **Deploy:** Reusable `deploy-ec2.yml` workflow, same as all other services

### Not Now: Edge CDN (Vercel, CloudFront, etc.)

- **When to revisit:** External users at scale need low-latency global delivery
- **Trigger:** A frontend serves non-Tailscale users and latency or availability matters
- **Until then:** Adding a vendor, auth context, and billing surface violates the constraint principle

## Graduation Rules

Every frontend starts at Tier 0.

**Tier 0 → Tier 1** when:
1. You need to share a clickable link with someone who isn't looking over your shoulder
2. You need to validate multi-page routing flows
3. The mockup has stabilized enough to persist in a repo

**Tier 1 → Tier 2** when:
1. The UI needs server-side secrets (DB credentials, API keys that can't live in a client bundle)
2. The UI needs SSR for SEO or first-paint performance
3. The UI needs to colocate with backend services (reading Postgres, calling OpenClaw)
4. The UI needs middleware (auth, redirects, request rewriting)
5. The UI needs persistent state (database, not just client-side)

If none of those are true, it stays where it is.

## Example: TwoDo

- **Tier 0:** Claude generates a React artifact — task list, status toggles, test history display. Validate the interaction model with mock data.
- **Tier 1:** Push to a repo, deploy to GitHub Pages. Share the link. Test multi-page flows (task list → task detail → test history). Still mock data.
- **Tier 2:** Wire up Postgres for persistent tasks and test history. Deploy to EC2. This is where TwoDo lives in production because it's a stateful app.

## Consequences

### Positive
- Tier 0 costs nothing and takes seconds — no repo, no CI, no deploy
- Forces UI validation before backend coupling
- Aligns with underfunding principle — spend nothing until you must
- Each tier uses only existing infrastructure (chat, GitHub, EC2)
- Clear graduation criteria prevent premature tier jumps

### Negative
- Tier 0 artifacts are ephemeral (acceptable — they're sketches, not deliverables)
- GitHub Pages has no server-side capabilities (acceptable — that's the constraint working)
- Three tiers require awareness of when to graduate (documented in rules above)

### Risks
- Staying at Tier 0 too long and never shipping (mitigated: graduation triggers are concrete)
- GitHub Pages rate limits (mitigated: internal use only, low traffic)
- Static export gotchas with Next.js (mitigated: `.nojekyll` + `basePath` solve the common issues)
