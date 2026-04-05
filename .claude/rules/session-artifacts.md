---
globs: ["*"]
description: Session artifacts — chronicle + LinkedIn drafts at every phase transition and session end
---

At ALL process levels (core, standard, full), these artifacts are mandatory.
They fire regardless of whether /autonomous is active.

## Backfill before current (MUST — applies to all artifacts below)

Before writing ANY session artifact (chronicle, LinkedIn, release notes):
1. Check when the last entry was written
2. Check how many sessions/commits/days are missing since then
3. If there are gaps: backfill them FIRST, in chronological order (oldest first)
4. THEN write the current session's artifact

This prevents out-of-order content in append-only destinations (Google Docs)
and ensures no session is silently skipped.

## Chronicle (MUST — every phase transition + session end)

Before ending any session or completing any phase transition:
1. Check: when was the last chronicle entry? How many commits since?
2. If ≥3 commits since last entry: backfill the missing chronicle(s) FIRST
3. Then write the current session's chronicle
4. Chronicle goes in the repo's existing chronicle directory:
   - Check docs/chronicle/ first
   - Then docs/design/chronicle/
   - Then chronicle/
   - If none exists, create docs/chronicle/
4. Verify the file exists after writing

## LinkedIn drafts (SHOULD — every notable decision or handoff)

At every role handoff, phase transition, or session end, ask:
"Did this session/phase/handoff produce a notable decision, trade-off,
or insight worth sharing?"

If yes:
1. Check for gaps: when was the last LinkedIn draft? Are there missed
   sessions that owed drafts? Backfill those FIRST, oldest to newest.
2. Create docs/linkedin-drafts/ if it doesn't exist
3. Write draft to docs/linkedin-drafts/YYYY-MM-DD.md
4. Push to Google Doc — push in chronological order (oldest first):
   GDOC_LINKEDIN_ID="1b1Gs8CDfOVF5D0ZaIswMWfW9JqQEgx0Zk409I9YfY7I" npx tsx ~/src/sunj-labs/poa/scripts/push-to-gdoc.ts --file [draft path]
4. Verify both the local file and Google Doc push succeeded

High-value moments for LinkedIn:
- Scope kills (Shaper cutting features)
- Architecture choices (Architect choosing boring tech)
- Process insights (what broke, what worked, what surprised)
- Design pushback (Designer vs PM)
- Quantified results (N agents, M minutes, K artifacts)

Every draft file MUST include an **audience recommendations table**:

| Post | Primary audience | Hook strength | Publish priority |
|------|-----------------|--------------|-----------------|

Target audiences: PE partners, executive search leaders, board-level
operators, CPTOs, technical founders, eng leaders/managers.
Rate hook strength (weak/medium/strong/very strong/strongest).
Recommend a publish sequence with rationale.
Note overlapping posts and recommend which to publish vs hold.

## This rule exists because

Agents forget to write session artifacts in long sessions, especially
after context compaction. Putting this in rules/ ensures it loads into
every session at every level. The choreography doc has the full protocol;
this rule is the reminder that fires regardless of mode.
