# SPEC-NNN: [Feature Name]

## Canvas Reference
Link to product canvas or PR/FAQ.

## Context
Why now? What triggered this work?

## Requirements
### Must Have
- ...
### Should Have
- ...
### Won't Have (this version)
- ...

## Design
### User Flow
Step-by-step, what the user (or system) does.

### Object Model
What are the core objects? How do they relate?
(Define objects, not screens.)

### Interface
Wireframe, CLI spec, API contract — whatever's appropriate.

## Technical Approach
Architecture, dependencies, risks.

## Deployment & Access Architecture

Answer these before writing code. The answers determine your deployment tier,
networking, auth, and domain strategy. See [ADR-005](../../architecture/decisions/ADR-005-frontend-deploy-tiers.md)
and [ADR-006](../../architecture/decisions/ADR-006-monitoring-telemetry.md).

### Who accesses this?

| Question | Answer |
|----------|--------|
| Is this operator-only (just you)? | yes / no |
| Will trusted people use it (family, partners, advisors)? | yes / no |
| Will the public use it (customers, strangers)? | yes / no |
| Does access need to work from outside the Tailscale mesh? | yes / no |

### What does it need?

| Question | Answer |
|----------|--------|
| Does it persist data (database, filesystem)? | yes / no |
| Does it handle secrets server-side (API keys, OAuth tokens)? | yes / no |
| Does it need SSR or API routes? | yes / no |
| Does it call other services on the EC2 stack? | yes / no |
| Does it need auth (login, user accounts)? | yes / no |

### Deployment decision

Based on the answers above:

| Condition | Tier |
|-----------|------|
| Operator-only, no persistence, validating UI | **Tier 0: Mockup** (Claude artifact, local dev) |
| Needs a shareable link, still mock data, no backend | **Tier 1: Prototype** (GitHub Pages static export) |
| Any "yes" to persistence, secrets, SSR, or backend calls | **Tier 2: Production** (Docker on EC2 via Tailscale) |
| Public users outside Tailscale mesh | **Tier 2 + reverse proxy** (Caddy/nginx with TLS, public domain) |

### If public-facing, additionally answer:

| Question | Answer |
|----------|--------|
| Domain name? | |
| TLS strategy? (Let's Encrypt via Caddy is default) | |
| Auth provider? (OAuth, magic link, none?) | |
| Rate limiting needed? | yes / no |
| Do we need a public status page? | yes / no |
| GDPR / data handling implications? | |

### Monitoring

| Question | Answer |
|----------|--------|
| Healthcheck endpoint path? | `/health` or specify |
| Add to Beszel container monitoring? | yes / no |
| Langfuse tracing needed? (LLM calls) | yes / no |
| Cost circuit breaker relevant? | yes / no |

## Acceptance Criteria
How we know it's done. Testable statements.

## Open Questions
Things we don't know yet.
