---
session_id: 2026-04-01-1400
project: canonical
agent: personal
status: completed
tags: [agentic, process-framework, agents, guardrails, manifest, cost-governance, mobile-testing, inheritance]
---

# Session: Agentic Framework — Process Framework v3, 10 Agents, Manifest, Budget

## Entry State
- Substrate built (rules, hooks, skills) but no formal process framework
- 3 utility agents (CodeReviewer, SpecWriter, SessionRetro) — no role-based personas
- No cost governance, no guardrails, no iteration planning
- Canonical inheritance working on cloud (confirmed: 18 skills synced)
- sdlc-checkpoint skill colliding with pre-build-gate hook
- Trace logs causing dirty tree / commit loops
- POA duplicates not fully cleaned

## Work Done

### Completed POA audit + cleanup (#28 — closed)
- Deleted 10 duplicate skills, 3 duplicate rules, 2 duplicate hooks from POA
- Created canonical templates for test-e2e, test-integration, deploy-prod, release-notes
- Established template+override pattern: canonical provides methodology, app provides specifics (#39 — closed)
- Promoted type-check hook and multi-tenancy-check hook (template) to canonical
- Expanded security rule with auth matrix + tenant isolation template
- Deleted POA's duplicate new-dependency-check and schema-management rules

### Fixed operational issues
- sdlc-checkpoint collision: demoted to reference doc, hook is sole enforcement
- Trace logs gitignored in both repos (were causing commit loops)
- canonical-sync.sh: added symlinks for skill auto-discovery, cloud ~/.claude/settings.json writing, boot check
- permissions.additionalDirectories in POA settings.json for automatic --add-dir

### Mobile/cloud testing (3 rounds)
- Round 1 (resume): stale — changes on feature branch, not main
- Round 2 (new): canonical cloned, skills visible but not auto-triggering
- Round 3 (new with symlinks): success — 18 skills, agent confirmed sync

### Merged to main
- Feature branch infrastructure merged to POA main so cloud sessions get it

### Full substrate inventory
- Produced comprehensive tables: 22 skills, 11 rules, 11 hooks, 10 agents
- Each with invocation trigger, POA concrete case, current vs target state
- Identified 16 missing capabilities for well-governed SDLC
- Prioritized by: autonomous now, real users, second repo, team growth, real pain

### Process framework v3
- Ingested canonical-session-guide-v3.md (from collaboration with another Claude session)
- Replaced process framework with v3: RUP phases, 10 agent roles with personas, risk/value iteration bets, Lean Product Triangle
- Key v3 additions: appetite in cost+turns (not days), manifest with core|standard|full levels, budget & model routing ($25 burst, per-agent model assignment)

### Built 10 agent definitions
- Shaper (opus, Inception), PM (sonnet), Designer (sonnet), Creative Director (sonnet), Architect (sonnet), Builder (sonnet), Reviewer (haiku), Deployer (haiku), Closer (haiku), Orchestrator (haiku)
- Each with persona, responsibilities, decision authority, handoff protocol, tool restrictions

### Cost governance + guardrails
- cost-governance.md: v3 budget behavior table, model routing, core-level advisory
- guardrails.md: what agents must never/always do, escalation paths, capability ceilings, graceful exit conditions, agent identity in artifacts

### Project manifest
- substrate.config.md template: core|standard|full with agents, phases, iterations, budget
- POA manifest at core level: Builder + Reviewer, light iterations, no ceremony
- Manifest is the dial — one line changes the operating model

### /promote workflow + canonical evolution
- /promote skill creates canonical-evolution issues
- Pre-commit gate checks .claude/ changes and suggests /promote
- Session-reflection shows pending evolution issues in canonical sessions
- Created canonical-evolution GitHub label

### Boot check integrated into session-start
- canonical-sync.sh checks for missing dependencies (Google SA key, gh auth)
- Non-blocking — reports what's missing, doesn't stop work

## Decisions Made
- **v3 supersedes v2**: appetite in cost+turns, manifest mechanism, budget routing
- **core level for POA**: no ceremony, Builder + Reviewer, light iterations
- **Manifest is opt-in, not enforcement yet**: #42 tickets the hook implementation
- **Template+override pattern**: canonical methodology + app specifics. deploy-prod candidate for next round.
- **sdlc-checkpoint demoted**: hook is enforcement, skill is reference only
- **10x rule**: substrate infrastructure (rules, hooks) earns its keep now. Process ceremony (10 agents, iteration bets) is forward investment — costs nothing to carry.
- **No canonical-light repo split**: one repo, manifest controls what activates

## Open Threads
- [ ] #40: Design agentic flow invocation (how to trigger multi-agent)
- [ ] #41: Design graceful exit + checkpointing for multi-agent
- [ ] #42: Implement manifest as enforceable hooks (not just declarative)
- [ ] #43: Manifest-aware session planning (bridge reflection to iteration bet)
- [ ] #36: Refactor hooks into canonical base + app extensions
- [ ] #37: SDLC compliance tracking (replace trace logs)
- [ ] #38: Plugin design for cleaner distribution
- [ ] Clean up stale agents in ~/.claude/agents/ (13 found, should be 10)
- [ ] Validate symlinked skills actually auto-trigger via Skill harness on cloud

## Key Files Changed
- `strategy/process-framework.md` — replaced with v3
- `.claude/agents/` — 10 new role-based agents (3 old utility agents removed)
- `.claude/rules/cost-governance.md` — v3 budget model
- `.claude/rules/guardrails.md` — NEW
- `.claude/skills/promote/SKILL.md` — NEW
- `.claude/skills/deploy-prod/SKILL.md` — NEW
- `.claude/skills/release-notes/SKILL.md` — NEW
- `.claude/skills/test-e2e/SKILL.md` — NEW canonical template
- `.claude/skills/test-integration/SKILL.md` — NEW canonical template
- `.claude/skills/sdlc-checkpoint/SKILL.md` — demoted to reference
- `.claude/hooks/pre-commit-gate.sh` — added .claude/ promote check
- `.claude/hooks/type-check.sh` — NEW
- `.claude/hooks/multi-tenancy-check.sh` — NEW template
- `strategy/templates/iteration-bet.md` — light + full formats, cost+turns
- `strategy/templates/risk-register.md` — NEW
- `strategy/templates/substrate-config.md` — NEW manifest template
- `poa/substrate.config.md` — NEW, core level
