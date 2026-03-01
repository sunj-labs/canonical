# ADR-003: Titans-Inspired Memory Layer for OpenClaw

## Status
DEFERRED

## Date
2026-02-28

## Revisit When
Deal pipeline hits 100-200 evaluated deals.

## Context
Google's Titans architecture introduces surprise-based neural memory — a compelling model for long-term agent context. However, the current memory problem is session continuity, not architectural memory limits.

The three-layer approach (git + CLAUDE.md + session logs) solves the immediate problem with zero new infrastructure.

## What Titans Would Give Us (When We Need It)

Titans combines short-term memory (attention), long-term memory (neural memory module with surprise-based storage), and persistent memory (fixed task knowledge). The MAC variant retrieves from long-term memory before attention runs, letting the model decide relevance. `lucidrains/titans-pytorch` is MIT-licensed, 1.9k stars, actively maintained (last release Feb 8 2026).

## Trigger Conditions for Revisiting

1. Deal pipeline is processing 100+ deals and agents need to learn patterns across evaluations
2. Session logs become unwieldy (50+ sessions per project)
3. Agent-to-agent context sharing becomes a bottleneck
4. GPU budget available for training

## When Triggered, the Path Is

**Option A:** ChromaDB vector store + surprise scoring as an approximation layer. Ships in 1-2 weeks. The vector store becomes training data for Option B.

**Option B:** Train a small Titans model on accumulated deal evaluation data using `lucidrains/titans-pytorch`. Requires Option A data as training set.

## Decision
DEFERRED. Current memory needs are met by git + CLAUDE.md + structured session logs. Revisit when trigger conditions are met.

## Consequences

### Positive
- No premature infrastructure investment
- Clear trigger conditions prevent indefinite deferral
- Option A → B path is incremental, not big-bang

### Negative
- Agents can't learn across sessions (acceptable at current volume)
- No surprise-based memory filtering (manual curation via session logs)
