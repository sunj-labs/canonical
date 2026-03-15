---
session_id: 2026-03-15b-pipeline-running
date: 2026-03-15
duration: ~2 hours (evening session)
repos: [sunj-labs/poa, sunj-labs/platform-docs]
tags: [bullmq, worker, circuit-breaker, bffs, multi-source, enrichment, production-readiness]
skills: [distributed-systems, queue-debugging, resilience-patterns, backlog-management]
---

# Session: Pipeline Running — 693 Deals, Worker Autonomous

## What Shipped

- **BullMQ prefix bug fixed**: Worker wasn't picking up jobs — Queue had `prefix: "poa"` but Worker didn't. Silent failure for ~30 minutes until diagnosed via Redis key inspection.
- **Per-source circuit breaker**: After 2 consecutive state failures, skip remaining states for that source. One unhealthy source (BBS timeouts) no longer blocks BFFS/enrichment/scoring.
- **693 deals**: BFFS scraped 9 SE US states (NC, SC, VA, GA, FL, TN, AL, MD, DE) — 600 new deals in one run.
- **Tighter intervals**: Scrape every 30m, enrich every 20m, score every 10m.
- **Digest limit fix**: Was showing 200 of 693 deals due to hardcoded `take: 200`.
- **8 new backlog items**: #15 (admin dashboard), #16 (credit governor), #20 (production deploy), #21 (detection), #22 (self-healing), #23 (per-source circuit breaker), #24 (cross-source dedupe), #25 (public data sources), #26 (data source research).

## What Was Learned

- **BullMQ Queue prefix must match Worker prefix.** If Queue uses `prefix: "poa"`, Worker must too. No error is thrown — jobs silently queue and never get processed. This is the kind of silent failure that #21 (alerting) would catch.
- **Per-source resilience is different from per-request resilience.** Exponential backoff handles individual request failures. But when an entire source is down, you need source-level circuit breaking to avoid blocking the pipeline.
- **BFFS is a better primary source than BBS.** 600 deals with descriptions + financials from search pages, zero enrichment needed, fast and reliable. BBS needs detail enrichment (intermittent) for the same data quality.

## Post Ideas

### 1. "Silent Failures in Distributed Queues: The Prefix Bug That Ate My Pipeline"

BullMQ has a `prefix` option that namespaces Redis keys so multiple apps can share one Redis instance. If the Queue has `prefix: "poa"` but the Worker doesn't, jobs queue at `poa:poa-scraper:wait` but the Worker listens on `poa-scraper:wait`. No error. No warning. Jobs accumulate forever. I spent 30 minutes watching "Listening on poa-scraper queue" while 4 jobs sat in a key the worker couldn't see. The fix was one line. The lesson: when a distributed system is silent, check whether the components agree on their addressing scheme.

### 2. "Source-Level Circuit Breakers: When One Bad API Shouldn't Block Your Pipeline"

Request-level retry with exponential backoff is table stakes. But when your scraper hits 9 states sequentially and the source is timing out on all of them, you burn 20 minutes of retries before the next source can run. The fix: track consecutive state failures per source. After 2 failures, skip the rest and move on. The source gets another chance next cycle. One unhealthy API shouldn't hold your entire pipeline hostage.
