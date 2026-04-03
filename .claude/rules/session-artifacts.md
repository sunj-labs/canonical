---
globs: ["*"]
description: Session artifacts — chronicle + LinkedIn drafts at every phase transition and session end
---

At ALL process levels (core, standard, full), these artifacts are mandatory.
They fire regardless of whether /autonomous is active.

## Chronicle (MUST — every phase transition + session end)

Before ending any session or completing any phase transition:
1. Check: when was the last chronicle entry? How many commits since?
2. If ≥3 commits since last entry: write the chronicle NOW
3. Chronicle goes in the repo's existing chronicle directory:
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
1. Create docs/linkedin-drafts/ if it doesn't exist
2. Write draft to docs/linkedin-drafts/YYYY-MM-DD.md
3. Push to Google Doc if script exists:
   cd ~/src/sunj-labs/poa && GDOC_LINKEDIN_ID="1b1Gs8CDfOVF5D0ZaIswMWfW9JqQEgx0Zk409I9YfY7I" npx tsx scripts/push-to-gdoc.ts --file [draft path]
4. Verify both the local file and Google Doc push succeeded

High-value moments for LinkedIn:
- Scope kills (Shaper cutting features)
- Architecture choices (Architect choosing boring tech)
- Process insights (what broke, what worked, what surprised)
- Design pushback (Designer vs PM)
- Quantified results (N agents, M minutes, K artifacts)

## This rule exists because

Agents forget to write session artifacts in long sessions, especially
after context compaction. Putting this in rules/ ensures it loads into
every session at every level. The choreography doc has the full protocol;
this rule is the reminder that fires regardless of mode.
