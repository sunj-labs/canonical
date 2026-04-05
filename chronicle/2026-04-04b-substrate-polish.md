---
session_id: 2026-04-04b
project: canonical
agent: human + claude
status: complete
tags: [substrate, security, linkedin, privacy, sprint]
---

# Chronicle: Substrate Polish & Sprint Skill

## Entry state
- Previous session shipped luminaries, prototype sprint, Playwright MCP integration
- 8-post LinkedIn series ("The Autonomous Enterprise") drafted but not anonymized
- Google Doc push script using relative paths causing cross-project permission prompts

## Work done
- `ecc6d39` — security: deploy-guard hook blocks git push to main without explicit approval
- `fc6b673` — docs: 8-post LinkedIn series with story arc for "The Autonomous Enterprise"
- `c57ebab` — fix: anonymize 8-post series — remove family references per privacy constraints
- `9e0f918` — feat: /sprint skill + substrate hardening iteration bet
- `766be0f` — fix: Google Doc push uses absolute path — stops cross-project permission prompts

## Decisions made
- **Deploy guard as hook**: push-to-main now requires explicit user approval via hook, not just convention. This hardens the "main is always deployable" guarantee.
- **Sprint skill created**: /sprint gives quick orientation — current iteration, open issues by tier, proposed next work. Useful for session start and re-orientation.
- **Substrate hardening bet**: formalized the next iteration as 6 issues focused on operator trust — cost tracking, self-test, session-end resilience, UX refinements.
- **Privacy anonymization**: LinkedIn series stripped of family references per privacy constraints. Content preserved, personal details removed.

## Open threads
- Substrate hardening iteration bet active — 7 issues (#74, #56, #46, #59, #72, #71, #45)
- 4 POA to-canonical promotions pending (#267, #268, #269, #271)
- Session lock false positive on startup needs resolution (relates to #46 self-test)

## Key files changed
- `.claude/hooks/deploy-guard.sh` (new)
- `.claude/skills/sprint/SKILL.md` (new)
- `docs/iteration-bets/2026-04-04-substrate-hardening.md` (new)
- `docs/linkedin-drafts/2026-04-04-autonomous-enterprise-series.md` (updated)
- `scripts/push-to-gdoc.ts` reference updated to absolute path
