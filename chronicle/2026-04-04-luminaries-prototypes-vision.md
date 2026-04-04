---
session_id: 2026-04-04-luminaries-prototypes-vision
project: canonical
agent: claude-opus-4.6
status: complete
tags: [luminaries, prototype-sprint, browser-verification, primary-luminary, playwright-mcp]
---

# Chronicle — 2026-04-04: Luminaries, Prototype Sprint, and Visual Verification

## Entry state

- Last chronicle: 2026-04-03 (autonomous infrastructure + first live run)
- POA running autonomous CRM iteration in parallel window (#285 auto-ingestion, #286 Outreach as primary)
- 4 research tickets open from yesterday (#66-69)
- Tier 2 fixes shipped yesterday, housekeeping needed

## Work done

### Housekeeping
- Closed 4 issues fixed in prior session (#52, #53, #54, #60)
- Removed 19 duplicate nested skill directories (boot script artifact)
- Added docs/sdlc-traces/ to .gitignore (mechanical hook output, local only)

### Research completed
- **Agent-browser (#66)**: Playwright MCP is the right tool. Installed at user level. Glance MCP as alternative for visual regression. ~30 min to integrate.
- **Anthropic frontend design skill (#69)**: Our Creative Director + Designer + frontend-design stack exceeds Anthropic's single published skill. We separate concerns they bundle. Worth reading their skill for scroll-triggered interactions and gradient meshes.

### Primary luminary concept (new)
- Optional `primary_luminary:` field in iteration bet (formal + light format)
- Orchestrator surfaces at boot, agents state how it influences their approach
- Tiebreaker when luminaries conflict, not an exclusion
- Added to process-framework.md, choreography, /autonomous scaffold prompt

### Prototype sprint skill (new)
- `/prototype-sprint` — 2-3 static HTML + Tailwind variants, each with different dominant luminary
- Operator picks up to 3 luminaries from a 22-luminary menu across 4 categories:
  UX/Interaction, Visual/Typography/Color, Information Architecture, Psychology/Persuasion
- Variants are throwaway (not full stack), viewable via `npx serve`
- Inserted as optional Elaboration step 0 in choreography
- Selection feeds into iteration bet's primary_luminary field

### Browser verification wiring
- Playwright MCP installed user-level (`claude mcp add playwright --scope user`)
- Wired into 4 agent definitions: Designer, Builder, Reviewer, Creative Director
- Added UI component/page row to /verify skill
- Added visual verification as check #8 in usability rule

### Expanded luminaries
Color psychology (entirely missing before):
- Eva Heller (Psychology of Color — empirical color-emotion research)
- Faber Birren (Color Psychology and Color Therapy — age-based preferences)
- Johannes Itten (The Art of Color — seven types of color contrast)

Behavior/persuasion (entirely missing before):
- BJ Fogg (Behavior Model — Motivation × Ability × Trigger)
- Robert Cialdini (Influence — six persuasion principles)
- Aarron Walter (Designing for Emotion — functional → pleasurable hierarchy)

Usability (foundational, should have been there):
- Jakob Nielsen (10 usability heuristics)
- Steve Krug (Don't Make Me Think)
- Susan Weinschenk (cognitive science behind user behavior)
- Jesse James Garrett (Elements of User Experience)
- Luke Wroblewski (mobile-first strategy)
- Golden Krishna (The Best Interface is No Interface)
- Edward Tufte (data visualization, data-ink ratio)

### Permissions fix
- Expanded canonical settings.json allow list: cp, mv, npm, npx, claude mcp, etc.
- Reduces autonomous session friction (fewer permission prompts)

## Decisions made

- **Primary luminary is a tiebreaker, not an exclusion** — all luminaries still inform, the primary breaks ties
- **Prototype sprint is opt-in** — Orchestrator asks during Elaboration, operator can skip
- **Prototypes are throwaway** — static HTML, not production code. Construction builds the real thing.
- **Playwright MCP at user level** — available in every repo, every session, without per-project config
- **HUD is a separate project** (#70) — it's an app, not docs. Needs its own canvas before building.
- **Color psychology was a gap** — Albers covers color theory (perception) but not color psychology (emotion). Now both are covered.

## Issues created

| # | Title |
|---|-------|
| 70 | HUD for canonical — new project |
| 71 | /autonomous UX refinements |
| 72 | Prototype sprint unlock language |

## Open threads

1. **Test prototype sprint in POA** — run against the Outreach page with 3 luminary variants
2. **POA parallel session** — auto-ingestion + Outreach-as-primary finishing in other window
3. **HUD canvas** (#70) — needs Thesis stage before any code. Separate project directory.
4. **Pluggable luminaries** (#68) — users adding their own thinkers to agents. Future.

## Key files changed

- `.claude/skills/prototype-sprint/SKILL.md` (new)
- `.claude/agents/designer.md` (expanded luminaries + visual verification)
- `.claude/agents/creative-director.md` (color psychology luminaries + visual verification)
- `.claude/agents/builder.md` (visual verification)
- `.claude/agents/reviewer.md` (visual verification)
- `.claude/skills/verify/SKILL.md` (UI component row)
- `.claude/rules/usability.md` (check #8)
- `strategy/process-framework.md` (primary_luminary field)
- `strategy/agent-choreography.md` (Elaboration step 0, luminaries table)
- `.claude/skills/autonomous/SKILL.md` (primary luminary prompt, Elaboration prototype)
- `.claude/settings.json` (expanded permissions)
