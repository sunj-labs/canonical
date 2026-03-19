---
session_id: 2026-03-17-multitenancy-hooks
date: 2026-03-17
duration: ~4 hours
repos: [sunj-labs/poa]
tags: [multi-tenancy, sdlc-hooks, gmail-ingestion, personas, permissions]
skills: [prisma-schema, next-auth, bullmq, sdlc-process, hook-design]
---

# Session: Multi-Tenancy, Gmail Ingestion, and SDLC Hooks

## What Shipped

- **Multi-tenancy schema** — Tenant, TenantMember, Thesis, ThesisWeight models. Five Pandas and POA as separate tenants.
- **Gmail email ingestion pipeline** — classify incoming emails (BBS alert, BQ alert, broker deal sheet, noise), parse deal data, upsert to shared pool. BullMQ scheduled every 15 min.
- **Persona-aware copy system** — OPERATOR (technical), COLLABORATOR (plain English), STUDENT (kid-friendly), ADVISOR (professional), INTERN (task-oriented). Fallback chains per persona.
- **Fine-grained permissions** — string array on User model: view_deals, vote, comment, outreach, prune, manage_searches, manage_theses, manage_members, admin.
- **SDLC hooks** — pre-build gate (Edit/Write), pre-commit gate (Bash), bug diagnosis (UserPromptSubmit), tool failure diagnosis (PostToolUse), session start/end.
- **Deploy fixes** — Docker image prune, GHCR auth with dedicated PAT, force-recreate containers, sed compose SHA tags.

## What Was Learned

- **SDLC hooks need enforcement, not just reminders** — hooks that say "you should" get ignored. Hooks that say "STOP — write this section before proceeding" are more effective.
- **PostToolUse diagnosis hook** catches errors Claude discovers (not just user-reported). Essential for preventing brute-force debugging.
- **Multi-tenancy must be designed before data flows** — adding Tenant model after 600+ deals means migration + backfill.
- **Persona copy system** needs fallback chains: STUDENT → COLLABORATOR → OPERATOR. Don't duplicate strings for every persona.
