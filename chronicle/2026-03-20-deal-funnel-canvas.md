---
session_id: 2026-03-20-deal-funnel-canvas
date: 2026-03-20
duration: ~4 hours (evening session)
repos: [sunj-labs/poa, sunj-labs/platform-docs]
tags: [canvas, enrichment, financial-metrics, ux-translation, architect-review, security]
---

# Session: Deal Funnel Canvas + Enrichment Pipeline + Security Fixes

## What Shipped

### Architect Review (2026-03-20b — Full)
- 33 commits since last full review → NOT READY verdict
- 4 critical security findings (API routes), 6 high, 11 medium
- 6 new issues created (#95-#100), all on project board

### Critical Security Fixes (#95)
- Gmail OAuth callback no longer exposes refresh token in HTML
- POST /api/digest now requires OPERATOR auth
- /api/deals sortBy parameter whitelisted (was accepting arbitrary columns → Prisma injection)
- /api/email/test deleted (was exposing PII publicly)

### Deal Funnel Canvas
- Three-tier funnel model: Wide Net → Selective Enrichment → Family Surface
- 11 requirements from user interview
- Financial metrics hierarchy: Revenue → EBITDA → SDE → FCF with bridge formulas
- Critical discovery: BBS "Cash Flow" field is actually SDE
- 17 BBS detail fields identified that we weren't extracting
- Decomposed into 4 epics: #90 (enrichment), #101 (terminology), #102 (dashboard), #103 (scoring)

### BBS Parser + Enricher (#90 E1+E2)
- Parser now extracts 24 fields (was 13): SBA eligible, building SF, lease expiration, reason for selling, business website, inventory, facilities, competition, growth, financing, support/training
- Enricher now saves ALL parsed fields (was saving only 8 of 13 extracted — 5 fields thrown away)
- Schema: added sde, sbaEligible, businessWebsite, buildingSqFt, leaseExpiration, reasonForSelling, realEstateType, enrichedAt
- enrichedAt enables "Not yet enriched" vs "Not disclosed" distinction

### Terminology Cleanup (#101 T1-T3)
- Source labels: FRANCHISE_RESALE → BusinessesForSale.com, BIZBUYSELL → BizBuySell
- Financial terms standardized: removed all persona-ized labels (Cash Flow is Cash Flow, not "Annual Income")
- Dashboard: "Your Deals" for family / "Pipeline Overview" for operator, date in header
- "Last Scrape" → "Last Import", "Active Searches" hidden from non-operators
- Deal detail: Price/SDE + Price/EBITDA ratios, SBA badge, new enrichment fields displayed

### UX Translation Chain (post-canvas)
- Task analysis: 3 deal views, SDE metrics, enrichment-aware evaluation
- IA model: Deal entity expanded, screen map with 3 views, epic table current
- User stories: 6 new (S17-S22), traceability matrix updated
- Interaction design: role-based landing, 3-view state diagram

### UX Fitness Review
- 27 Prisma entities, 5 with UI surface (15% coverage)
- IA-to-code alignment: 9/10, no drift
- Key gaps: DealList UI, deal status workflow, COLLABORATOR dashboard

### Tests: 196 → 212 (+16 new)

## What Was Learned

- **BBS "Cash Flow" = SDE**: This changes how we interpret and display financial data from our primary source. SDE is higher than EBITDA because it includes owner salary as profit. For small business (<$5M) acquisitions, Price/SDE is the primary valuation multiple.
- **Enricher was throwing away data**: The parser extracted 13 fields but the enricher only saved 8. Five fields (revenue, real estate value, absentee owner, asking price, location) were parsed and discarded. Always trace data from source → parser → upsert → display.
- **Session-end hook fires after stop**: The hook outputs instructions but Claude is already terminated. Chronicles were never written because no Claude was alive to receive the instruction. Root cause of missing chronicles since session start.
- **Persona-izing financial terms confuses users**: "Annual Income (what the owner takes home)" for Cash Flow made family members MORE confused, not less. Industry terms are the lingua franca — don't invent labels for standardized M&A terminology.
- **"Not disclosed" is misleading**: When the enricher hasn't run, showing "Not disclosed" implies the source withheld the data. Often the source has rich data we haven't extracted yet. Three states: not enriched, not disclosed, has value.

---

## Post Ideas

### 1. "Your AI Doesn't Have a Data Problem. It Has a Funnel Problem."

We built a deal sourcing engine that scraped 1,830 business listings from three sources. Impressive volume. But only 5 had cash flow data. Zero had EBITDA. Our AI scoring system dutifully scored all 1,830 — and produced meaningless results, because it was imputing neutral values for every missing field. The family logged in, saw 1,830 deals clustered at score 35, and asked: "Why can't I find a single good business?"

The fix wasn't more data or better models. It was a funnel. Tier 1: cast a wide net (free scraping, high volume, minimal data). Tier 2: selectively enrich only the deals that pass hard filters — price range, geography, industry (each enrichment call costs money and time). Tier 3: show the family only the deals with real financial data above a quality threshold. The AI scoring system didn't change. The data feeding it did. Three concepts commercial leaders should internalize: **data quality gates** (don't process garbage at scale — filter first), **selective enrichment** (spend your API/compute budget on candidates that already pass basic criteria), and **threshold-gated surfaces** (don't show users everything you know — show them what's actionable). PE firms running deal sourcing with AI: if your team is drowning in low-quality deal flow, you don't need a better model. You need a better funnel.

### 2. "SDE Is Not EBITDA: Why Your AI's Financial Vocabulary Matters More Than Its Architecture"

Our system scraped a pediatric practice listed at $2.25M on BizBuySell. The listing clearly showed Cash Flow (SDE): $500,000 and EBITDA: $500,000. Our platform stored the $500K as "Cash Flow" and displayed "EBITDA: Not disclosed." The actual BBS listing page had 17 structured fields we weren't extracting — including the EBITDA we claimed was missing. The system was simultaneously data-rich at the source and data-poor in the product.

The deeper issue: BizBuySell labels their field "Cash Flow (SDE)" — Seller's Discretionary Earnings, not operating cash flow. SDE = EBITDA + owner's salary + personal expenses. For a business with $170K EBITDA, the SDE might be $265K — a 56% difference. When your AI treats these as interchangeable, your valuation multiples are wrong, your scoring is wrong, and your deal recommendations are wrong. Three concepts that matter here: **source semantics** (the same field name means different things on different platforms — your ingestion pipeline must track what each source actually provides), **the SDE-EBITDA bridge** (SDE is the standard for small owner-operated businesses because the buyer replaces the owner; EBITDA is for larger businesses where management is an expense), and **metric-aware scoring** (Price/SDE of 2.5x is a good deal; Price/EBITDA of 2.5x is an exceptional deal — your system must know which it's computing). For PE operating partners evaluating bolt-on acquisitions or search fund sponsors screening targets: if your deal sourcing tool doesn't distinguish SDE from EBITDA, every multiple it shows you is suspect.

### 3. "We Found 4 Security Vulnerabilities in Production Code That Passed Every Test"

Our platform had 196 passing tests, 3 architect reviews, and a CI/CD pipeline with smoke tests. It also had an API endpoint that displayed Gmail refresh tokens in the browser. Another endpoint let anyone on the internet trigger email sends to all users. A third accepted arbitrary database column names in query parameters. A fourth exposed email subjects, senders, and body previews with no authentication. None of these were new code — they'd been in production for days. None were caught by tests, CI, or previous reviews.

The architect review that found them wasn't triggered by an incident. It was triggered by a commit counter: every 10 commits, run a full review. The review read every API route, checked auth patterns, traced input validation, and audited the CI/CD pipeline. Four critical findings, six high, eleven medium — from a codebase that was "passing all tests." Three concepts for technology leaders: **security is not testable by unit tests alone** (tests verify behavior you thought of; vulnerabilities live in behavior you didn't), **periodic architectural audits at fixed intervals** (don't wait for incidents — the 10-commit cadence caught issues that three prior reviews missed because prior reviews were scoped to recent changes), and **input validation at system boundaries** (the sortBy injection wasn't a SQL injection — it was a Prisma ORM injection, a class of vulnerability most teams don't even know to test for). For CISOs and PE operating partners running due diligence: ask your portfolio companies when they last ran a full architectural security audit — not a pen test, not a scan, but a human (or AI) reading every API route. If the answer is "never" or "at launch," you have the same four vulnerabilities we did.

### 4. "The Session-End Hook That Never Fired: A Parable About Process Automation"

We built a rigorous SDLC process: hooks that fire before commits, before builds, at session start, at session end. The session-end hook was supposed to enforce chronicle writing — a narrative record of what shipped, what was learned, and what post ideas emerged. It had been in place for 6 days. It had fired 30+ times. Zero chronicles were written during session end. The hook worked perfectly: it detected the stop event, printed mandatory instructions, and exited cleanly. The problem: it fired AFTER the AI agent terminated. It was shouting instructions into an empty room.

This is a perfect metaphor for process automation in any organization. The gate existed. The enforcement mechanism existed. The audit trail showed it firing correctly. But the sequencing was wrong — the check happened at a point in the lifecycle where no actor could respond to it. Three concepts: **gate sequencing matters more than gate existence** (a pre-commit hook that blocks is worth ten post-commit hooks that warn — the same applies to deal approval workflows, compliance checks, and QA gates), **audit trails can show false compliance** (our trace log showed 30+ session-end events, creating the appearance of process discipline, while zero chronicles were actually written), and **recovery mechanisms must be independent of the failed process** (the fix: session-start checks for missing chronicles and forces recovery before allowing new work — the enforcement moved to a different lifecycle event with a living actor). For COOs and transformation leaders: audit your automated workflows for gates that fire at the wrong lifecycle stage. If your compliance check runs after the trade is executed, it's not a control — it's a notification.

### 5. "81% of Our Data Model Has No User Interface — And That's Exactly Right"

Our UX fitness review revealed that only 5 of 27 database entities have a user interface. The other 22 — financial projections, broker communications, milestone tracking, curated deal lists, location profiles, notification queues — exist in the schema but are invisible to users. A product manager would call this a crisis. We call it a deliberate funnel.

The entity coverage scorecard: Deal sourcing (57% coverage — the core loop works), Auth (14% — sign-in only), Financial analysis (0%), Timeline (0%), Collaboration (0%). But the entities aren't wasted — they're infrastructure for features that haven't earned their way into the UI yet. The Deal Funnel canvas introduced a principle: don't surface data to users until it's actionable. 1,830 deals with imputed scores aren't actionable. 50 enriched deals with real SDE and EBITDA are. Three concepts: **entity coverage is not a KPI** (having 27 models doesn't mean you need 27 pages — premature UI creates noise, not value), **infrastructure-first for data products** (build the schema, the ingestion, the scoring engine — then expose the results only when data quality justifies user attention), and **the OOUX screen derivation rule** (each primary entity gets a list view and a detail view — but only when it's a primary entity for a user job, not just because it exists in the database). For digital transformation leaders and product executives: if your team is building UI for every data model, they're optimizing for feature count, not user outcomes. The right question isn't "what percentage of our data model is exposed?" — it's "can users accomplish their jobs with what's exposed?"
