---
name: architect-review
description: Full architectural review — C4 model, ADR fitness, security audit, CLAUDE.md audit. Run every 10 commits or before launch.
user_invocable: true
disable_model_invocation: false
---

# Architect Review

Comprehensive architectural review. Triggered:
- After every **10 commits** since the last review
- Before any **user-facing launch**
- After any **critical security change** (auth, middleware, tenant isolation)

## Procedure

1. **Read the previous review** in `docs/architecture/reviews/` to compare against

2. **Explore the codebase** — read all key architectural files:
   - Database schema (Prisma, SQL, or equivalent)
   - Auth boundary (middleware, session management)
   - Job orchestration (queues, workers, schedulers)
   - All agents / autonomous components
   - External service integrations
   - API routes
   - CI/CD pipeline
   - Dockerfile / container config

3. **Assess each area**:
   - **Component architecture** — C4 Level 2 diagram, component boundaries
   - **Data flow** — ingestion → processing → display pipeline
   - **Auth & security** — session management, tenant isolation, API auth
   - **Queue & workers** — job routing, scheduling, failure modes
   - **External dependencies** — failure modes, circuit breakers, cost control
   - **Error handling** — silent failures, logging, observability
   - **Database** — N+1 queries, unbounded queries, missing indexes
   - **Testing** — what's covered, what's not
   - **Performance** — page load times, query efficiency
   - **ADR fitness** — are past architectural decisions still valid?
   - **CLAUDE.md fitness** (see step 3b)

3b. **CLAUDE.md audit** — the operating manual must enable a fresh session
    to execute the SDLC with fidelity. Verify:
    - Stack section matches actual dependencies
    - Skills table lists every skill — none missing, none stale
    - Key Commands actually work
    - Key Files list reflects current codebase
    - Conventions match current practice
    - Session Protocol reflects current hooks
    - No bloat — remove anything derivable from the code itself

4. **Produce the report** at `docs/architecture/reviews/YYYY-MM-DD.md`:
   - Verdict: READY / NOT READY
   - Critical blockers (must fix)
   - High/medium/low findings
   - Component map (Mermaid)
   - Security audit summary
   - Test coverage assessment
   - Recommendations by priority
   - ADR fitness check
   - CLAUDE.md fitness: what was stale, what was fixed

5. **Significance check per finding**:
   - Classify: trivial / moderate / significant
   - Check: does this impact a UI surface?
   - Moderate+: create a GitHub issue
   - Trivial: note in the report, no ticket needed

6. **Create tickets** — one per moderate+ finding. Not optional.

7. **Commit** the review document
