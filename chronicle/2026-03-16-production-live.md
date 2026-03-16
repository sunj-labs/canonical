---
session_id: 2026-03-16-production-live
date: 2026-03-16
duration: ~3 hours (evening into midnight)
repos: [sunj-labs/poa, sunj-labs/ops]
tags: [production-deploy, docker, ci-cd, circuit-breaker, ec2, danger-mode]
skills: [devops, docker-compose, github-actions, ssh-deployment, distributed-systems, resilience-patterns]
---

# Session: Production Live — 622 Deals Scored on EC2

## What Shipped

- **POA deployed to production** on EC2 (100.89.2.128:3001 via Tailscale)
- **Worker running autonomously** on EC2 — scrape/enrich/score on schedule
- **622 deals scraped and scored** on production in first run
- **Circuit breaker fix** — all scrapers: retries 4→1, bail after 2 state failures. BBS run time: 20+ min → ~2 min.
- **GitHub Actions workflow** — builds Docker image to GHCR on every push
- **CI/CD secrets** (SSH) configured on both repos
- **First danger mode summary** written

## What Was Learned

- **Docker `restart` doesn't reload env files** — need `down` + `up` to pick up `.env.production` changes
- **Next.js inlines `process.env` at build time** — setting env vars at runtime doesn't affect server components. Need `next.config.ts` env exposure.
- **ANSI escape codes in migration SQL** — `prisma migrate diff` captures terminal color codes. Strip before committing.
- **BullMQ Queue prefix must match Worker prefix** — silent failure, jobs queue but never process. No error thrown.
- **tsx needs `--tsconfig` flag** in Docker for `@/` path alias resolution
- **Per-source circuit breaker is essential** — one unhealthy source shouldn't block the entire pipeline. 4 retries × 9 states = 20 minutes of waste.

---

## Post Ideas

### 1. "From Empty Repo to 622 Deals in Production: A Weekend with AI-Assisted Development"

Saturday morning: an empty repository and a conversation about my parents' care needs. Saturday night: 622 business listings across 9 US states, scraped from 2 sources, scored on 3 dimensions, displayed on a live dashboard, running autonomously on EC2. The system scrapes every 30 minutes, scores every 10 minutes, and will keep working while I sleep. The secret wasn't typing faster — it was the horizontal slice strategy: thin through the whole pipeline first, then deepen each step. Most of the session was spent on requirements, architecture, and process design — not code.

### 2. "The Silent Failure Pattern: When Distributed Systems Don't Tell You They're Broken"

Three silent failures in one deploy session: BullMQ Queue prefix mismatch (jobs queue, worker doesn't see them, no error), Docker restart not reloading env files (container starts, old config persists, no warning), and Next.js build-time env inlining (env var set at runtime, server component ignores it, no indication). Each took 15-30 minutes to diagnose. The pattern: distributed systems fail silently when components disagree on configuration. The fix: always verify the component received what you think you sent.
