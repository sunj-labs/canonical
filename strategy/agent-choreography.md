# Agent Choreography — Operational Guide for Multi-Agent Sessions

> The Orchestrator reads this document at session init. It is the conductor's
> score — it tells each agent when to play, what to produce, and who picks up
> after them. The process framework (`strategy/process-framework.md`) defines
> the *what*. This document defines the *how*.

---

## 1. Orchestrator Boot Sequence

On every session init at `standard` or `full` process level, the Orchestrator
executes this checklist in order. No work is scheduled until all steps pass.

```
1. READ MANIFEST
   → Read substrate.config.md
   → Confirm process level (core/standard/full)
   → Confirm active agents list
   → Confirm budget (session_ceiling, iteration_ceiling, model_routing)
   → If iteration_ceiling missing → ASK OPERATOR. Do not assume.

2. READ PHASE STATE
   → Read docs/phase-state.md (format defined in Section 6)
   → If file missing → assume Inception, create the file
   → Confirm: current phase, current iteration, open risks

3. READ ITERATION BET
   → Read the active iteration bet (path in phase-state.md)
   → Validate: risk + value + lovability + viability signal all present
   → If incomplete → do not schedule. Flag to operator.
   → NOTE: The iteration bet declares its own phase (e.g., Inception for a
     new subsystem even if the project is broadly in Construction). Use the
     iteration bet's phase for choreography, not the project-level phase.
     This allows subsystems at different maturity levels in the same repo.

4. MAP SKILLS TO AGENTS
   → Read all .claude/skills/*/SKILL.md files
   → Bind each skill to agent(s) per the mapping table (Section 2)
   → Log bindings (available to all agents via phase-state.md)

5. CHECK RISK REGISTER
   → Read the risk register (path in phase-state.md or docs/risk-register.md)
   → Surface all open risks ranked by likelihood × impact
   → Confirm the current iteration addresses the top risk for this phase

6. CHECK SESSION LOCK
   → Per session-continuity.md parallel safety protocol
   → If lock exists and < 2 hours old → STOP, ask operator
   → If lock exists and > 2 hours old → warn, proceed carefully
   → Write SESSION_LOCK with agent ID + timestamp

7. CHECK FOR MISSING ARTIFACTS
   → Chronicles: commits since last entry? If ≥3, write the missing chronicle first.
   → Architect review: ≥10 commits since last? Schedule before other work.
   → Danger mode summary: auto-complete used without summary? Write it.

8. PROPOSE WORK
   → Summarize: phase, iteration, top risks, proposed agent activations
   → WAIT FOR OPERATOR CONFIRMATION before scheduling any agent
```

At `core` level, skip steps 2-5. The human is the orchestrator. Rules, hooks,
skills, and the Builder + Reviewer agents are active. Light iteration format.

---

## 2. Skill-to-Agent Mapping Table

The Orchestrator binds these at session init. Agents do not self-assign skills.

| Skill | Primary Agent | Secondary Agent(s) | Phase |
|-------|--------------|-------------------|-------|
| `/canvas` | Shaper (problem framing) | PM (viability layer) | Inception |
| `/spec` | Shaper / PM | Architect (validates) | Inception → Elaboration |
| `/diagnose` | Builder | Any agent on failure | Any |
| `/temperance` | Builder | Any agent before non-trivial work | Any |
| `/verify` | Builder | — | Construction |
| `/architect-review` | Reviewer | Architect (at Elaboration gate) | Elaboration, Construction |
| `/principal-engineer` | Architect | Reviewer (during PR eval) | Elaboration, Construction |
| `/frontend-design` | Creative Director (guidance) | Builder (execution) | Elaboration → Construction |
| `/jtbd-tasks` | Designer | — | Elaboration |
| `/task-scenarios` | Designer | — | Elaboration |
| `/ia-model` | Designer | — | Elaboration |
| `/interaction-design` | Designer | — | Elaboration |
| `/sdlc-checkpoint` | Orchestrator (reference) | Builder (pre-build gate) | Any |
| `/test-integration` | Builder | Reviewer (validates) | Construction |
| `/test-e2e` | Deployer | — | Transition |
| `/deploy-prod` | Deployer | — | Transition |
| `/release-notes` | Deployer | — | Transition |
| `/chronicle` | Closer | Any agent at session end | Any |
| `/retro` | Closer | — | Transition |
| `/linkedin` | Closer | — | Transition |
| `/feynman` | Any | — | Any (explanation) |
| `/promote` | Any | — | Any (canonical evolution) |

**Multi-agent skill bindings** (both agents are required, not optional):
- `/canvas` → Shaper writes problem framing, then PM completes viability layer. One artifact, two agents, clean handoff.
- `/architect-review` → Reviewer invokes during PR eval; Architect invokes at Elaboration gate.

---

## 3. Phase Choreography

The Orchestrator selects the choreography based on the **iteration bet's phase**,
not the project-level phase. A mature app (project phase: Construction) can run
Inception choreography for a new subsystem if the iteration bet says so.

This means a single repo can have:
- Deal pipeline → Construction (shipping, tested, stable)
- CRM module → Inception (canvas, shaping, risk identification)
- Notifications → Elaboration (architecture, design artifacts)

Each iteration bet declares its phase. The Orchestrator runs the matching
choreography below.

### Inception — "Is this worth building?"

```
Orchestrator
  → activates Shaper (opus model for problem framing)
    Shaper:
      1. /canvas — Stage 1 (Thesis): value prop, audience, problem, bet
      2. Conviction check — does it pass? If no → STOP. Idea killed.
      3. /canvas — Stage 2 (Shape): PR/FAQ, personas, key outcomes
      4. Set appetite (fixed time, variable scope)
      5. Populate risk register (≥3 risks, typed and ranked)
      6. Define scope boundary (what's IN, what's explicitly OUT)
      → HANDOFF: Canvas (problem framing layer) + risk register

  → activates PM (sonnet)
    PM:
      1. Complete canvas viability layer
      2. Write first viability hypothesis (untested)
      3. Define success metrics
      4. Write iteration bet (value + viability signal sections)
      → HANDOFF: Completed canvas + viability hypothesis + iteration bet draft

  → activates Creative Director (sonnet) — if UI work is in scope
    Creative Director:
      1. Define visual language, tone, brand constraints
      2. Produce creative brief
      3. Seed design tokens
      → HANDOFF: Creative brief + design tokens

  Orchestrator validates Inception gate:
    [ ] Vision doc (canvas) with scope boundary
    [ ] Risk register populated (≥3 risks ranked)
    [ ] Appetite set
    [ ] Viability hypothesis written
    [ ] Build/buy/defer decision recorded
    → If all met → advance to Elaboration
    → If not → surface gaps to operator
```

### Elaboration — "Prove the architecture. Kill the biggest risks."

```
Orchestrator
  → activates Architect (sonnet)
    Architect:
      1. Build C4 Context + Container diagrams
      2. Write ADRs for load-bearing decisions
      3. Prototype against top technical risks (from risk register)
      4. Define component boundaries and interfaces
      5. /principal-engineer — pattern review
      6. /architect-review — at Lifecycle Architecture Milestone
      → HANDOFF: Accepted ADRs + C4 diagrams + component boundaries

  → activates Designer (sonnet) — parallel with Architect if independent
    Designer:
      1. /jtbd-tasks — jobs-to-be-done → task analysis
      2. /task-scenarios — task analysis → user stories
      3. /ia-model — information architecture
      4. /interaction-design — state diagrams, sequence diagrams, flows
      5. Validate at least one user-facing concept for lovability
      → HANDOFF: Design artifacts in substrate (docs/design/ux/)

  → activates PM (sonnet) — confirms viability survives elaboration
    PM:
      1. Review Architect's ADRs for business impact
      2. Confirm viability hypothesis survives elaboration findings
      3. Write iteration plan for Construction
      4. Complete iteration bet for first Construction iteration
      → HANDOFF: Validated iteration bet + Construction plan

  Orchestrator validates Elaboration gate:
    [ ] C4 diagrams in substrate
    [ ] Riskiest unknowns resolved
    [ ] ADRs written (status: accepted)
    [ ] Designer validated at least one concept
    [ ] PM confirmed viability survives
    [ ] Iteration plan for Construction exists
    → If all met → advance to Construction
```

### Construction — "Build it. Iterate. Ship working software."

```
Orchestrator reads the iteration plan. Each iteration:

  1. VALIDATE ITERATION BET
     → Risk + value + lovability + viability signal all present
     → Appetite confirmed (cost ceiling, turn limit)

  2. PLAN BRANCH STACK (see standards/branch-stacking.md)
     → Builder (or Orchestrator at full level) writes stack manifest
     → Declare branches, dependencies, parallel-safety

  3. EXECUTE — sequential or parallel per stack manifest

     For each branch:
       → activates Builder (sonnet)
         Builder:
           1. /temperance — pause, think, simplest approach
           2. /sdlc-checkpoint — spec current? diagrams loaded?
           3. Implement against spec acceptance criteria
           4. /verify — appropriate to change type
           5. Commit (conventional commits, references issue)
           6. Open PR with context
           → HANDOFF: PR ready for review

       → activates Designer (sonnet) — validates UI branches
         Designer:
           1. Review implementation against design artifacts
           2. Sign off or flag discrepancies
           → HANDOFF: Designer sign-off (or rejection with reasons)

       → activates Reviewer (haiku) — read-only
         Reviewer:
           1. Evaluate PR against spec acceptance criteria
           2. Verify test coverage
           3. Check ADR compliance
           4. Confirm Designer sign-off present
           5. /architect-review if architecture-significant change
           → HANDOFF: Approve / Request changes / Block

       → Builder merges on approval (squash merge to main)

  4. ITERATION CLOSE
     → Orchestrator checks: appetite consumed? scope completed?
     → PM evaluates viability signal
     → If more iterations planned → loop to step 1
     → If Construction complete → advance to Transition

  ON ANY FAILURE during Construction:
    Builder: /temperance → /diagnose → fix → /verify
    If blocked after 3 diagnosis attempts → escalate to Architect
    If scope expanding → escalate to Orchestrator (appetite enforcement)
```

### Transition — "Hand off. Stabilize. Close the loop."

```
Orchestrator
  → activates Deployer (haiku)
    Deployer:
      1. /deploy-prod — execute release process
      2. /test-e2e — post-deploy verification
      3. /release-notes — for user-facing changes
      4. Write runbook in substrate
      → HANDOFF: Deployed + verified + runbook written

  → activates Creative Director (sonnet) — spot-check
    Creative Director:
      1. Review deployed output for brand coherence
      → HANDOFF: Brand sign-off or flags

  → activates PM (sonnet)
    PM:
      1. Evaluate viability hypotheses: proven or disproven?
      2. Write PM retrospective
      → HANDOFF: Viability assessment

  → activates Closer (haiku)
    Closer:
      1. Evaluate Product Release gate checklist
      2. Triage open issues: fix now, defer, or close
      3. Update ADR statuses if needed
      4. /retro — write retrospective
      5. /chronicle — write session chronicle
      6. /linkedin — if session shipped something worth sharing
      → HANDOFF: Phase declared complete

  Orchestrator validates Transition gate:
    [ ] User/operator acceptance confirmed
    [ ] Runbook in substrate
    [ ] Open issues triaged
    [ ] Retrospective written
    [ ] PM viability retrospective complete
    → If all met → phase complete. Remove SESSION_LOCK.
```

---

## 4. Handoff Protocol

Every handoff between agents produces a **substrate artifact** — a file at a
known path that the next agent reads. No verbal state. No implicit context.

### Artifact locations by phase

| Phase | Artifact | Path | Producer | Consumer |
|-------|----------|------|----------|----------|
| Inception | Product Canvas | `docs/strategy/canvases/YYYY-MM-DD-slug.md` | Shaper + PM | Architect, Designer |
| Inception | Risk Register | `docs/risk-register.md` | Shaper | Orchestrator, Architect |
| Inception | Viability Hypothesis | In canvas or iteration bet | PM | Orchestrator, Closer |
| Inception | Creative Brief | `docs/design/creative-brief.md` | Creative Director | Designer |
| Inception | Design Tokens | `docs/design/tokens/` | Creative Director | Designer, Builder |
| Elaboration | C4 Diagrams | `docs/architecture/c4/` | Architect | Builder, Reviewer |
| Elaboration | ADRs | `docs/architecture/decisions/` | Architect | Builder, Reviewer |
| Elaboration | UX Artifacts | `docs/design/ux/` | Designer | Builder |
| Elaboration | Iteration Plan | In iteration bet or `docs/iteration-plan.md` | PM | Orchestrator |
| Construction | Branch Stack Manifest | `docs/branch-stacks/YYYY-MM-DD-slug.md` | Builder/Orchestrator | All agents |
| Construction | PRs | GitHub | Builder | Reviewer, Designer |
| Construction | Verify Evidence | In PR description or commit | Builder | Reviewer |
| Transition | Release Notes | `docs/release-notes/YYYY-MM-DD.md` | Deployer | Closer, PM |
| Transition | Runbook | `docs/runbooks/` | Deployer | Operator |
| Transition | Retrospective | `docs/retros/YYYY-MM-DD.md` | Closer | Orchestrator |
| Transition | Chronicle | `docs/chronicle/YYYY-MM-DD-slug.md` | Closer | Next session |

### Handoff mechanics

When an agent completes its work:

1. **Write the artifact** to the path above
2. **Commit** with conventional commit referencing the phase and iteration
3. **Signal completion** — in a multi-agent session, the Orchestrator detects
   the commit and activates the next agent. In a single-session context, the
   agent states what it produced and what agent should pick up next.

The Orchestrator never passes context verbally between agents. It points the
next agent at the artifact path. The artifact is the interface.

---

## 5. Agent Activation Mechanics

### How agents are invoked

At `standard` and `full` level, agents are invoked as Claude Code subagents:

```bash
# Worktree agent (isolated branch)
claude -w --agent=builder "Implement stack-2 per spec at docs/specs/crm.md"

# Same-session subagent (shared context)
# Via the Agent tool with subagent_type matching the agent name
```

At `core` level, the human invokes skills directly. The Builder and Reviewer
personas are implicit in the main session agent.

### Parallel activation rules

- **Independent agents can run in parallel** — Architect and Designer during
  Elaboration (if their work doesn't overlap)
- **Dependent agents run sequentially** — Builder before Reviewer, always
- **Never two writers on the same branch** — SESSION_LOCK or worktree isolation
- **Orchestrator monitors all active agents** — detects conflicts, enforces
  appetite across the aggregate session

### Model assignment

The Orchestrator assigns models per the manifest's `model_routing` section.
Agents do not choose their own model. If an agent needs escalation (e.g.,
Shaper needs opus outside Inception), it requests via Orchestrator, who logs
the escalation and cost delta.

---

## 6. Phase State File

The Orchestrator maintains phase state at `docs/phase-state.md`. This is the
single source of truth for "where are we."

```markdown
# Phase State

## Project-level phase
phase: Construction
note: The project as a whole is in Construction. Individual subsystems
      may be at different phases — see iteration bets for specifics.

## Active iteration
iteration_bet: docs/iteration-bets/2026-04-02-crm-build.md
iteration_phase: Inception  ← this overrides project phase for choreography
branch_stack: docs/branch-stacks/2026-04-02-crm-stack.md

## Active agents
- Shaper (inception, CRM canvas)
- PM (awaiting Shaper handoff)

## Subsystem phases
Tracks maturity of each subsystem independently. The Orchestrator uses the
iteration bet's phase for choreography, not the project-level phase.

| Subsystem | Phase | Last iteration | Notes |
|-----------|-------|---------------|-------|
| Deal pipeline | Construction | 2026-04-01 | Stable, 500+ tests |
| Scoring & enrichment | Construction | 2026-03-30 | SDE-aware scoring live |
| Communications | Construction | 2026-04-02 | Email parser, outreach confirmation |
| CRM | Inception | — | New subsystem, no artifacts yet |
| Notifications | Not started | — | — |

## Gate progress (project-level)
### Inception — COMPLETE (2026-03-15)
- [x] Vision doc with scope boundary
- [x] Risk register populated
- [x] Appetite set
- [x] Viability hypothesis written
- [x] Build/buy/defer: BUILD

### Elaboration — COMPLETE (2026-03-22)
- [x] C4 diagrams
- [x] Riskiest unknowns resolved
- [x] ADRs accepted
- [x] Designer validated concept
- [x] PM confirmed viability
- [x] Construction iteration plan

### Construction — IN PROGRESS
- [x] Deal pipeline: sourcing, scoring, enrichment
- [x] Communications: digests, outreach, confirmation parsing
- [ ] CRM: inception pending
- [ ] Ceremony: family voting live, deployment pending

## Risk register
See docs/risk-register.md
Last reviewed: 2026-04-02 (iteration 2 start)
Top open risk: R-003 (Tech) — API auth boundary undefined
```

This file is updated by the Orchestrator at:
- Session init (read + verify)
- Phase transitions (advance phase, update gates)
- Iteration boundaries (new iteration, update progress)
- Agent activation/deactivation (track who's working on what)

---

## 7. Process Level Summary

| Concern | Core | Standard | Full |
|---------|------|----------|------|
| Active agents | Builder, Reviewer | + Architect, PM, Designer | All 10 |
| Phase gates | Skipped | Active | Enforced |
| Risk register | No | Yes | Yes, reviewed each iteration |
| Iteration bet | Light format (3-5 lines) | Formal | Full 4-signal |
| Orchestrator | Human | Human or agent | Agent |
| Skill mapping | Implicit | Orchestrator maps | Orchestrator maps |
| Branch stacking | Manual | Manifest recommended | Manifest required |
| Phase state file | Not required | Recommended | Required |
| Handoff protocol | Informal (commits) | Artifacts at known paths | Artifacts + Orchestrator routing |
| Parallel agents | Manual worktrees | Orchestrator-guided | Orchestrator-managed |

---

## 8. Quick Reference — "Who Do I Call?"

For agents unsure who to escalate to:

| I need... | Ask... |
|-----------|--------|
| Scope clarification | Shaper |
| "Is this worth building?" | PM |
| Architecture decision | Architect |
| UX pattern guidance | Designer |
| Visual language / brand | Creative Director |
| "What should I work on next?" | Orchestrator |
| "Can I merge this?" | Reviewer |
| "How do I deploy this?" | Deployer |
| "Are we done?" | Closer |
| "Who resolves this conflict?" | Orchestrator |
