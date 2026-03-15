---
session_id: 2026-03-15-flywheel-spinning
date: 2026-03-15
duration: ~5 hours
repos: [sunj-labs/poa, sunj-labs/platform-docs, sunj-labs/ops]
tags: [deal-sourcing, scraping, scoring, enrichment, ontology, flywheel, sdlc-evolution, adr, non-blocking-retry, multi-source]
skills: [web-scraping, anti-bot-bypass, data-pipeline, html-parsing, bullmq-workers, exponential-backoff, circuit-breakers, system-design, taxonomy-design, architectural-decisions]
---

# Session: Flywheel Spinning — 93 Deals, 2 Sources, Running Autonomously

## What Shipped

### Data Pipeline
- **ScraperAPI + cheerio pipeline**: Pivoted from Playwright (Akamai blocked). ScraperAPI ($49/mo Hobby) for bot bypass, cheerio for parsing. Proved on 2 sources.
- **BusinessesForSale.com adapter**: Second data source proving source-agnostic architecture (ADR-001). 23 deals, zero errors, richer data than BizBuySell (descriptions + financials from search page).
- **93 deals in pipeline**: 70 BizBuySell + 23 BFFS, all scored.
- **Detail enrichment**: 13 BBS deals enriched with yearEstablished, descriptions, broker info. ScraperAPI intermittent on detail pages.
- **Non-blocking two-pass enrichment**: Pass 1 skips on first failure (15s), Pass 2 retries with backoff. Formalized in BullMQ worker.
- **BullMQ worker running autonomously**: scrape every 30m, enrich every 20m, score every 10m.

### Scoring + Dashboard + Digest
- **3-dimension scoring**: price fit, business maturity, franchise penalty. Enriched deals show real differentiation (1971 business scores 91 vs 2024 business scores 25).
- **Live dashboard**: scored deals with color-coded badges, score bars.
- **Digest email**: score distribution bar chart, deal cards with data completeness indicators, pipeline health section.

### Architecture + SDLC
- **ADR-001**: Shared pipeline architecture. Ontology/thesis separation — same ontology, different weighting lens per use case (POA defensive vs roll-up offensive).
- **SDLC Rule 7**: Material backlog items trigger design review.
- **Flywheel diagram**: Core system loop (Data → Analysis → Communication → Decision → Feedback) as first-class design artifact, checked every session Reflect.
- **Agent definition formalized**: Trigger + authority + decision-making + side effects. Agents use tools, tools don't use agents.
- **Core loop trigger**: When 2+ agents hand off to each other, map the flywheel before building any individual agent.

### Backlog Created
- #7: Email alert ingestion
- #8: Franchise + multi-period EBITDA
- #9: Business maturity filter
- #10: Auto-outreach engine
- #11: Detail enrichment gap
- #12: Shared pipeline architecture
- #13: AI disruption targeting strategy
- #14: Non-blocking enrichment (CLOSED — shipped)
- #15: Admin console health dashboard
- #16: Credit budget governor
- #17: Industry ontology
- #18: NAICS imputation
- #19: Investment thesis engine

## What Was Learned

- **BFFS > BBS for data quality from search pages.** BusinessesForSale.com gives descriptions, revenue, and cash flow right from the search results. BizBuySell requires detail page enrichment for the same data. Source selection matters more than enrichment strategy.
- **Circuit breaker state persists across tests.** Stale failure state masked a working solution for 30 minutes. Meta-lesson: reset accumulated state before testing any fix.
- **The ontology is the landscape, the thesis interprets it.** Same AI-exposure property means "avoid" for defensive investing and "target" for roll-up. The separation is architectural, not just conceptual.
- **Horizontal slice velocity compounds.** By having the full pipeline working (thin), adding a second data source took 15 minutes — write the adapter, run it, deals flow through scoring and dashboard automatically.
- **ScraperAPI is reliable for search pages, intermittent for detail pages.** Even on the paid tier, BizBuySell detail pages get 500s ~50% of the time. The two-pass non-blocking pattern handles this gracefully.

## SDLC Evolution

- **Rule 7**: Material backlog items trigger design artifact review.
- **Flywheel in Reflect**: Every session checks the core loop — which segment is weakest?
- **Agent definition**: Formalized in shared object model. Trigger + authority + decision-making + side effects.
- **Core loop trigger**: When 2+ agents hand off, map the flywheel first.
- **Architectural insights → ADR + epic immediately**: Don't defer to memory alone.
- **Ticket hygiene**: Update GitHub tickets when features evolve during implementation.
- **Session awareness**: Detect session boundaries, run Reflect proactively.
- **Reset state when debugging**: Stale circuit breakers, caches, counters mask working solutions.

## Collaboration Model

Human drove strategic insights: BFFS as richer source than BBS, ontology/thesis separation, roll-up as offensive thesis using same data, credit budget concerns, non-blocking retry pattern, admin visibility requirements. AI drove implementation: adapter code, enrichment pipeline, worker scheduling, backoff logic, ticket creation.

Pattern: human identifies the structural gap, AI fills it with code + artifacts, human stress-tests the result, loop continues.

---

## Post Ideas

### 1. "93 Deals in 5 Hours: Building a Multi-Source Deal Pipeline with AI"

Started the day with an empty database and a broken Playwright scraper. By evening: 93 deals from 2 sources, scored on 3 dimensions, displayed on a live dashboard, with an email digest ready to send. The secret wasn't the code — it was the horizontal slice strategy. Build thin through the whole pipeline first, then deepen each step. A second data source took 15 minutes to add because the normalization layer was already proven.

### 2. "The Ontology Is the Landscape, the Thesis Is the Lens: Designing for Multiple Investment Strategies"

We're building a deal sourcing platform that serves three use cases: defensive acquisition (recession-proof businesses for family care), offensive roll-up (AI-disruptable businesses to consolidate and automate), and real estate exchange (1031 tax-deferred). The insight: don't score businesses as "good" or "bad" — describe their objective properties (AI exposure, fragmentation, data intensity). Then let each search apply its own weighting lens. The same industry that's "avoid" for one thesis is "target" for another.

### 3. "Circuit Breakers Are State, and State Lies: A Debugging Lesson from Production Scraping"

We spent 30 minutes concluding that ScraperAPI couldn't handle BizBuySell detail pages. We tested multiple configurations, tiers, timeout values. Everything failed. The real problem: a circuit breaker from earlier failures was blocking requests before they even reached the API. One `resetCircuitBreaker()` call later, the detail pages worked perfectly. The meta-lesson applies everywhere: when debugging a failure, reset all accumulated state before testing a fix. Stale state masks working solutions.
