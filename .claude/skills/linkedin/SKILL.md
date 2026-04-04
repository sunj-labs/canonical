---
name: linkedin
description: Draft LinkedIn posts from session work — calibrated to PE/search/board audience per writing guide and brand questionnaire.
user_invocable: true
disable_model_invocation: false
---

# LinkedIn — Draft Posts from Session Work

Draft 3 LinkedIn posts from the current session's work, calibrated to
Sanjay's target audience and brand positioning.

## Before writing

1. Read `standards/writing-guide.md` — the LinkedIn style guide
2. Read the brand questionnaire from memory (reference_brand_questionnaire.md)
   for audience, tone, topics, and positioning
3. Read the current session's chronicle entry for raw material

## Audience (every post must land for these)

- **PE senior partners** — evaluating operating talent, backing transformations
- **Executive search leaders** — placing CEO/COO/CPTO into complex environments
- **Board-level decision-makers** — responsible for enterprise transformation mandates
- **CTOs asked to vet** — they'll check technical credibility

## Rules

- **Name concepts, not implementations.** "Governance primitive" not "SKILL.md file."
  See the vocabulary table in the writing guide.
- **Connect to enterprise economics.** Every post must touch EBITDA, capital
  efficiency, governance, operating model, or scale.
- **Bezos/Jassy/Collison tone.** Calm, analytical, operator-grade. No AI hype.
- **Structure**: Hook → Setup → Body (with → arrows) → Takeaway
- **600-1200 words** per post
- **3-7 posts per session** — different angles on the same work. More is fine
  if the session produced multiple notable moments.

## Audience recommendations table (MUST — include in every draft file)

Every draft file must start with a master audience recommendations table:

```markdown
| # | Title | Primary audience | Hook strength | Publish priority |
|---|-------|-----------------|--------------|-----------------|
| 1 | [title] | [audience] — "[angle]" | Weak/Medium/Strong/Very strong/Strongest | [priority or "Hold"] |
```

For each post, specify:
- **Primary audience**: PE partners, CPTOs, eng leaders, board, technical founders, QA leads, DevOps
- **Hook strength**: rate honestly. "Very strong" = contrarian or cautionary. "Strongest" = thought leadership.
- **Publish priority**: recommended sequence with rationale, or "Hold" for article/longer form
- **Overlap notes**: if two posts cover similar ground, recommend which to publish and which to hold

End the table with:
- **Recommended publish sequence** with rationale (e.g., "contrarian hook → framework → honesty → depth")
- **Hold for articles** — posts that work better as longer LinkedIn articles

## When a concept needs technical explanation

Flag it for the /feynman skill. In the draft, mark it:

```
[FEYNMAN: concept name — for CTO sidebar]
```

After drafting all 3 posts, run /feynman on each flagged concept.
Weave the Feynman explanation into the post or note it as a comment-thread follow-up.

## Output

1. Check for gaps: when was the last LinkedIn draft? Are there missed
   sessions? **Backfill those FIRST, oldest to newest** (per session-artifacts rule).
2. Write drafts to `docs/linkedin-drafts/YYYY-MM-DD.md` with audience
   recommendations table at the top
3. Push to Google Doc — in chronological order (oldest first):
   ```bash
   # Read GDOC_LINKEDIN_ID from substrate.config.md or project memory
   # If not configured, check for push-to-gdoc.ts script in the repo
   cd ~/src/sunj-labs/poa && npx tsx scripts/push-to-gdoc.ts --file [draft path]
   ```
4. **Verify the push succeeded** — check the output for "Appended N chars"
5. Note in the chronicle that posts were drafted and pushed
6. If Google Doc push fails (no script, no auth): drafts stay local in
   `docs/linkedin-drafts/`. This is acceptable — the content exists.
