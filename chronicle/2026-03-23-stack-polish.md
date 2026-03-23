---
session_id: 2026-03-23-stack-polish
date: 2026-03-23
duration: ~3 hours (multi-session day)
repos: [sunj-labs/poa]
tags: [refactoring, dedup, ceremony, insights, scoring, testing, architecture]
---

# Session: Stack Polish — Dedup, Ceremony, and Family Insights

## What Shipped

### 1. Family Insights Page (#144)
- Pipeline charts with weekly deal flow, source distribution, score distribution
- Server-rendered SVG bars for zero-JS performance
- CF floor filtering for pipeline funnel metrics

### 2. Ceremony Actions Wired (#91, #155)
- Promote/Reject/Request Info buttons on review detail page
- Renamed "shortlist" → "top scoring" across UI to match family language
- Ceremony actions update deal status via API

### 3. Scoring Audit (#141)
- Raised cash flow neutral imputation from 0 → 30 (missing data no longer tanks scores)
- Lowered review page threshold from 55 → 50 to surface more deals for family review
- Aligns scoring pipeline with real-world observation: most deals lack CF data early

### 4. Digest UX Polish
- Table layout for email client compatibility (replaces flexbox)
- Higher contrast score badges (accessibility — family member is 76)
- Review CTAs in digest link directly to review pages with magic auth tokens

### 5. Deal Track Fix (#157)
- Eliminated 'unknown' track — deals without RE signal classified as 'operating'
- Production migration: UPDATE dealTrack 'unknown' → 'operating'

### 6. Stack Dedup Refactor (4 commits)
- Extracted `formatCurrency` and `scoreColor` to `lib/format.ts` (was in 4 files)
- Created `lib/constants.ts` — single source of truth for `CF_FLOOR` and `DIMENSION_LABELS`
- Extracted `DetailRow` component (was duplicated in deals/[id] and review/[id])
- Net: +59 −78 lines across the dedup commits — less code, fewer drift risks

### 7. Digest Catch-Up Tests (#154)
- Extracted `shouldCatchUpDigest` as pure function in `lib/digest-catchup.ts`
- 6 unit tests covering time-gate and idempotency
- Issue #154 closed

### 8. Architect Review (26 commits)
- Full C4 + ADR + security audit covering review page, 3-queue architecture, ceremony

## What Was Learned

**Dedup reveals design drift.** The `DIMENSION_LABELS` mapping existed in 3 files with subtle differences — digest used "Cash Flow" while pages used "Cash Flow Yield". Without a single source of truth, labels silently diverge. The `CF_FLOOR` constant (250K) was in 4 files. One copy changing without the others would break the pipeline funnel.

**Enrichment context matters for null display.** `formatCurrency(null)` means different things: on a deal that hasn't been enriched, null means "we don't know yet." On an enriched deal, null means "broker didn't disclose." The deal detail page needs this distinction; the digest doesn't. Extracting the pure formatter revealed this semantic gap.

**Mirror tests remain valuable even after extraction.** The ceremony test for `CF_FLOOR` now imports from the constant rather than hardcoding 250K. This is better — it tests that the constant exists and equals the expected value — but the mirror pattern (test duplicates the value) still catches if someone changes the constant without understanding downstream impact.

## Post Ideas

1. **"The Three Copies Problem"** — When you find the same constant in 3 files, the real bug isn't the duplication — it's that nobody noticed they already disagreed. `DIMENSION_LABELS` had "Cash Flow" in one file and "Cash Flow Yield" in another. A dedup refactor isn't just about DRY; it's about discovering semantic drift that was invisible. Three concepts: single source of truth, semantic drift, design archaeology.

2. **"Null Doesn't Mean Nothing"** — In a deal sourcing pipeline, `formatCurrency(null)` has three meanings: "not yet scraped," "scraped but not disclosed," and "genuinely zero." Extracting a shared formatter forced the question: what does null mean in each context? The answer shaped the API: the shared function handles the common case, and the enrichment-aware wrapper handles the domain case. Three concepts: null semantics, context-dependent formatting, domain wrappers.

3. **"Scoring Neutral: The Case for 30"** — When 80% of deals have missing cash flow data, imputing zero tanks every score. Raising the neutral to 30 (midpoint) means "we don't know" instead of "this is bad." The scoring pipeline went from clustering at the bottom to actually distributing deals across tiers. Three concepts: imputation bias, neutral defaults, data sparsity in early pipelines.

4. **"Accessibility Is a Family Affair"** — Building a deal platform for a family that includes a 76-year-old collaborator. Translucent badges are trendy but invisible to aging eyes. Solid high-contrast colors aren't fashionable — they're functional. Designing for your actual users, not your design system's defaults. Three concepts: real-user accessibility, age-inclusive design, contrast over fashion.

5. **"The 'Unknown' Track That Held 40% of Deals"** — We had a deal classification system with two tracks: 1031 (real estate) and Operating (cash flow). But 40% of deals were silently landing in "unknown" — a track that existed in the database but not in any UI. One migration query later, the pipeline funnel actually added up. Three concepts: invisible categories, data hygiene, the gap between schema and UI.
