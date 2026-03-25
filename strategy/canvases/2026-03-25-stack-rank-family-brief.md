# Operator Stack Rank & Family Brief — Product Canvas

## Stage 1: Thesis

### Value Proposition (one sentence)

For **the operator preparing the family's first deal review call**, Stack Rank lets the operator curate, order, and annotate a shortlist of businesses, then share it as a brief the family can read before the call and reference during it.

### Audience Scope

Scope: **Operator**

Would I use this *this week*? Yes — Sunday March 29 family call. Brief out by Friday March 27.

### The Problem

The platform has 2,000+ deals scored across 8 dimensions, but no way for the operator to say "these are the 7 I want the family to look at, in this order, for these reasons." The scoring engine ranks by formula; the operator ranks by judgment informed by the formula. Today those two views are the same page — the family sees a sorted list of deals and has no signal about which ones the operator has actually vetted and wants to discuss.

The family is busy and geographically distributed. They won't browse 2,000 deals. They need a curated, operator-annotated list they can read in 5 minutes before a call. The operator needs to prepare that list efficiently — selecting from the scored pipeline, reordering, adding context — and send it out as a shareable brief.

### The Bet

If the operator can curate a stack-ranked shortlist with annotations and share it as a standalone brief, the family call becomes a structured discussion about specific businesses rather than an open-ended "what do you think?" conversation. This is the bridge from the Decision segment (yellow) to the Feedback segment (red) of the flywheel — the first real family engagement loop.

### Conviction check

Operator scope: passes. Using it Sunday. The family call won't work without it.

---

## Stage 2: Shape

### One-Paragraph PR/FAQ

The operator can now curate a ranked shortlist of businesses from the scored pipeline, add per-deal annotations explaining why each one matters, and share the result as a brief that family members can read before a call. The brief shows the operator's take alongside the system's score, links to full deal detail in the app, and supports voting — turning a passive email digest into an active discussion guide.

### Users / Personas

1. **Sanjay (Operator)** — curates the list, writes annotations, sends the brief, drives the call
2. **Family members (Collaborators)** — receive the brief, read before call, vote/comment, discuss on call
3. **System (Scorer/Enricher)** — surfaces candidates, provides scores and financial data

### Access Scope

- [x] Trusted circle (family — authenticated)
- Operator creates/edits the stack rank
- Family views the brief (read-only shareable page)

### Key Outcomes

1. **Family receives curated brief by Friday March 27** — first structured deal package
2. **Sunday call has an agenda** — 7 specific businesses to discuss, not open browsing
3. **Operator judgment is visible alongside system scoring** — family sees both perspectives
4. **Flywheel Decision→Feedback segment activates** — family votes on curated deals, operator learns preferences

---

## Stage 3: Commit

Operator scope — skip full PR/FAQ. Go to spec.

### Risks & Assumptions

| Risk | Mitigation |
|------|-----------|
| Scope creep — chat/NLP, PDF, Meet agent | Phase: (1) stack rank + brief page by Friday. (2) Chat as stretch. PDF and Meet agent are separate epics. |
| Mobile curation — operator may be on phone | Up/down arrows for reorder, not drag/drop. Text inputs for annotations. |
| Family doesn't read the brief before call | Brief is short (7 deals), scannable, operator take is the first thing they see. Screen share as backup. |
| NLP chat scope too large for Friday | Start with structured filters (track, price range, state, industry, score). Chat is aspirational for this sprint. |

### Constraints

- **Hard deadline**: Brief sent to family by **Friday March 27 EOD**
- **Technical**: No new infrastructure (no vector DB, no new LLM integration for chat). Use existing Prisma queries + existing Anthropic SDK.
- **Mobile**: Must work on phone for both curation (operator) and reading (family)

### What's in scope (Friday)

1. Stack Rank page — operator selects deals, reorders with up/down, adds per-deal annotation
2. Brief page — shareable URL, read-only, operator take + system score + deal snapshot
3. Operator portfolio summary at top of brief
4. Link from brief to full deal detail (existing review page)

### What's deferred

| Feature | When | Ticket |
|---------|------|--------|
| Chat/NLP deal discovery | Phase 2 (post-call) | Create after this ships |
| PDF export of brief | Phase 2 | Create after this ships |
| Google Meet transcription agent | Separate initiative | Create epic |
| Digest dedup (don't re-send seen deals) | Parallel track | #173 |

### Design artifacts needed

- [ ] ERD update (new StackRank / CuratedList entity)
- [ ] State diagram (brief lifecycle: draft → sent → discussed)
- [ ] Sequence diagram (operator curate → send → family view → vote)
- [ ] Screen wireframes (stack rank editor, brief view)
- [ ] IA update (new page in nav, or nested under Review?)
