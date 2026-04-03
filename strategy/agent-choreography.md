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

---

## 9. Deterministic Gates (MUST / SHOULD / MAY)

These gates determine trustworthy execution. MUST gates cannot be skipped
under any circumstances. SHOULD gates can be deferred with documented
rationale. MAY gates are best practice.

### MUST gates — never skip, no exceptions

| Gate | When | What | Who enforces |
|------|------|------|-------------|
| Spec before code | Before any Construction work begins | A spec (from `/spec` or `/canvas` Stage 2+) must exist and be referenced by the iteration bet. No code without a spec. | Orchestrator |
| GitHub issue before branch | Before creating any branch | Every branch ties to a GitHub issue. No branch without an issue. No work without a ticket. | Orchestrator, Builder |
| `/verify` after each task | After every build task, before commit | Run verification appropriate to change type | Builder |
| Tests pass | Before every commit of source code | New exported function = new test. No "I'll add tests later." | Builder, Reviewer |
| `/temperance` before non-trivial work | Before any implementation that touches >1 file or modifies behavior | Pause: simplest approach? brute-forcing? blast radius? | Builder |
| `/diagnose` before any fix | Any observed failure, before writing fix code | Is/Is Not + Five Whys + Hypothesis. No retry without understanding. | Builder |
| Chronicle at phase transition | Every phase transition + iteration end | Write to chronicle directory. Captures what the phase produced, decisions made, open threads. A role handoff within a phase updates phase-state; a phase transition writes a chronicle. | Orchestrator triggers, Closer writes |
| Conventional commits | Every commit | Type: description, imperative mood, references issue | Builder |
| ADR compliance | Every PR in Construction | No accepted ADR violated. Violations are blockers. | Reviewer |
| Designer sign-off | Every PR with UI changes | Designer validates implementation matches intent | Reviewer (checks sign-off exists) |
| Handoff artifact | Every role transition | Substrate artifact at known path. No verbal state. | Orchestrator |
| Phase-state update | Every checkpoint (see Section 10) | `docs/phase-state.md` reflects current reality | Orchestrator |

### SHOULD gates — defer only with documented rationale

| Gate | When | What |
|------|------|------|
| Architect review | Every 10 commits | Full architectural review. Schedule as first task if overdue. |
| Risk register review | Each iteration start | Surface open risks, confirm iteration addresses top risk. |
| Stale artifact cleanup | Session start | Write missing chronicles, danger summaries before new work. |
| Usability check | UI changes | 7-point check per standards/usability-check.md. |

### MAY gates — best practice, not enforced

| Gate | When | What |
|------|------|------|
| LinkedIn post | Session shipped something notable | Draft post to configured destination. |
| Release notes | User-facing changes deployed | Plain language for least technical stakeholder. |
| Danger mode summary | Auto-complete was used | Compact audit trail of autonomous decisions. |

---

## 10. Checkpointing Protocol

Checkpoints ensure that if a session dies at any point, the next session
can resume from a known state rather than restarting.

### When to checkpoint

Every agent checkpoints after completing a meaningful unit of work:

| Agent | Checkpoint after | What to persist |
|-------|-----------------|----------------|
| Shaper | Each canvas stage, risk register | Canvas file + phase-state update |
| PM | Viability hypothesis, iteration bet | Bet file + phase-state update |
| Creative Director | Creative brief, design tokens | Brief file + phase-state update |
| Architect | Each ADR, C4 diagram | ADR/diagram file + phase-state update |
| Designer | Each UX artifact (HTA, IA, flows) | Artifact file + phase-state update |
| Builder | Each task (not batched) | Commit + phase-state + stack manifest update |
| Reviewer | Each PR review | Review result in PR + phase-state update |
| Deployer | Each deploy step | Deploy status + phase-state update |
| Closer | Each closure artifact | Artifact file + phase-state update |
| Orchestrator | Every handoff, phase transition | Phase-state is your primary artifact |

### How to checkpoint

1. **Commit the artifact** — conventional commit, references issue
2. **Update `docs/phase-state.md`** — current agent, what's done, what's next
3. **Push** — if network available. If not, commit locally (push on next opportunity).

### Resume protocol

On `/autonomous start`, Step 6 (Resolve Stale Artifacts) checks for
partial state. If `docs/phase-state.md` shows work in progress:

1. Read the phase-state to understand where the last session stopped
2. Read the last committed artifacts to verify they're complete
3. Present to operator: "Last session stopped during [phase], [agent]
   was working on [task]. Completed: [list]. Remaining: [list].
   Resume from here, or restart?"
4. On resume: activate the agent that was interrupted, pointing it at
   the remaining work
5. On restart: operator decides what to keep/discard

---

## 11. Luminaries Reference

Each agent boots with awareness of the thinkers who inform their discipline.
These are codified in the agent definitions at `~/.claude/agents/*.md`.

| Discipline | Key luminaries |
|-----------|----------------|
| Business Modeling / Shaping | Christensen (JTBD), Amazon (PR/FAQ), Ohno (Five Whys), Wu (Anthropic) |
| Product Strategy | Christensen (JTBD), Kalbach (JTBD Playbook), DORA (metrics), Lean Canvas |
| Architecture | Brown (C4), Nygard (ADRs), Martin (SOLID), Evans (DDD), Larman (UML) |
| UX / Design | Annett/Duncan (HTA), Prater (OOUX), Cooper (Goal-Directed), Norman, Morville/Rosenfeld (IA), Covert, Wurman (LATCH), Cohn (User Stories), Tidwell (Interaction Patterns) |
| Creative Direction | Lupton (Storytelling, Typography), Albers (Color), Apple HIG, Google Material |
| Implementation | GoF (Design Patterns), Fowler (Enterprise Patterns), Martin (SOLID), Beck/Cunningham (TDD), Conventional Commits |
| Testing / Review | Martin (SOLID), Fowler (Patterns), Beck (TDD), Brown (C4 boundaries) |
| Problem Solving | Ohno (Five Whys), Kepner-Tregoe (Is/Is Not) |
| Deployment / Operations | DORA (metrics), Mermaid (diagrams) |
| Coordination | Cherny (Anthropic, worktrees), Wu (Anthropic, process), Ordax (.claude infrastructure) |

Source document: `~/Documents/AI Exchange/sdlc-luminaries.docx`

---

## 12a. Context Management Strategy

Long-running autonomous sessions will hit context window limits. This is
not a failure — it's expected. The strategy prevents it from degrading
execution quality.

### The problem

In sequential mode, one session plays all roles. By the time the Builder
starts Construction, the context may be 70%+ full from Inception and
Elaboration artifacts. The agent loses awareness of the spec, the iteration
bet, and the MUST gates.

### Strategy by execution mode

**Parallel mode** (Cherny's approach — context is not a problem):
- Each subagent/worktree agent has its own fresh context
- Scope is atomic: one branch, one task, one agent
- Context never fills because the work is small
- This is why parallel mode is more reliable for large builds

**Sequential mode** (one session — requires active management):

The agent MUST manage context proactively using three mechanisms:

#### 1. Checkpoint-and-reload at role transitions

When switching roles (e.g., Shaper → PM → Architect → Builder):
- Commit all artifacts from the current role
- The handoff artifact IS the context for the next role
- The next role reads ONLY what it needs:
  - Its agent definition (`~/.claude/agents/{role}.md`)
  - The iteration bet
  - The handoff artifact from the previous role
  - The MUST gates from this document (Section 9)
- Everything else can be compacted away

#### 2. Context budget awareness

| Context level | Action |
|--------------|--------|
| < 50% | Normal operation |
| 50-70% | Start being selective about what to read. Use Glob/Grep, not full file reads. |
| 70% | **Checkpoint now.** Commit all work. Write phase-state. The system will auto-compact prior messages. Ensure the iteration bet, current spec, and MUST gates survive compaction by re-reading them after compaction. |
| 90% | **Phase transition or branch boundary.** Complete the current atomic task, commit, update phase-state. If more work remains, the session can continue (compaction will free space) but re-read critical context. |

#### 3. Critical context that must survive compaction

After any compaction event, the agent MUST re-read these files to
ensure they're in the active window:

1. **Iteration bet** — scope, phase, appetite, acceptance criteria
2. **Current spec** — what's being built
3. **MUST gates** — Section 9 of this document (or the rules in CLAUDE.md)
4. **Phase-state** — where we are, what's done, what's next
5. **Branch stack manifest** — if in Construction, which branch, what's left
6. **Current agent definition** — luminaries, checkpointing, rules

These six files are the "survival kit." If compaction drops them, re-read
before continuing.

### Transition hierarchy — when artifacts fire

Every handoff is a transition. The artifacts that fire depend on the
level of transition:

```
Role handoff (Shaper → PM, Builder → Reviewer, etc.)
  MUST: checkpoint + commit artifact + update phase-state
  SHOULD: LinkedIn draft — if the handoff produced a notable decision,
    trade-off, or insight. The best posts come from thinking phases
    (Shaper killing a bad idea, Architect choosing boring tech, Designer
    pushing back on scope). Capture these at the handoff while the
    reasoning is fresh, not at iteration end when it's buried.
  This is the atomic unit. Every role switch persists state.

Phase transition (Inception → Elaboration, Elaboration → Construction, etc.)
  MUST: everything above PLUS chronicle entry
  SHOULD: LinkedIn draft — phase transitions are natural post boundaries
    ("what we learned in Inception," "why we chose this architecture")
  A phase transition is a meaningful boundary — it captures what the
  phase produced, what decisions were made, what's open. If the session
  dies during the next phase, this chronicle is the recovery point.

Iteration complete (through Transition phase)
  MUST: everything above PLUS retro
  SHOULD: LinkedIn post (polished from drafts accumulated during handoffs)
  MAY: release notes (if deployed)
  This is the full wrap-up. The Closer executes here, polishing any
  LinkedIn drafts from earlier handoffs into a final post.
```

**Chronicle timing** (MUST at every phase transition):
- Inception → Elaboration: chronicle captures the canvas, scope, risks, bet
- Elaboration → Construction: chronicle captures ADRs, design artifacts, iteration plan
- Construction → Transition: chronicle captures what was built, PRs, test results
- Transition complete: chronicle captures deploy, retro, viability assessment

In sequential mode: the agent writes the chronicle inline at each phase boundary.
In parallel mode: the Orchestrator triggers the Closer subagent at each boundary.

**LinkedIn drafts** (SHOULD — at role handoffs and phase transitions):
- Each agent, before handing off, asks: "Did this phase produce a
  notable decision, trade-off, or insight worth sharing?"
- If yes: write a draft to `docs/linkedin-drafts/YYYY-MM-DD-slug.md`
- These are raw drafts — the reasoning while it's fresh
- At iteration end, the Closer polishes drafts into a final post
- If Google Doc auth isn't available, drafts stay in `docs/linkedin-drafts/`
- The best posts come from Inception and Elaboration, not Construction

**The guarantee**: even if a session dies mid-flight, the checkpoint
protocol ensures phase-state is current at the last role handoff, and a
chronicle exists for every completed phase. The next session's boot
sequence detects gaps and fills them before starting new work.

---

## 12. Branching Strategy by Autonomous Mode

Every autonomous mode uses stacked atomic branches (see `standards/branch-stacking.md`).
The branching behavior varies by execution mode and gating. The constant:
**every branch is independently revertable. You can reject any PR without
tangling the rest.**

### Branching rules by mode

| Mode + Gating | Branching behavior | Rollback cost |
|---------------|-------------------|--------------|
| Sequential + human-gated | One branch at a time. Human reviews PR before next branch starts. Each branch merges to main before the next begins. | Drop any PR. Zero tangling. |
| Sequential + orchestrator-gated | One branch at a time. Agent chains through without pausing. PRs opened but not merged until human reviews post-session. | Reject any PR from the stack. Dependents discarded per manifest. |
| Parallel + human-gated | Independent branches in worktrees simultaneously. Human reviews each PR. | Drop any PR. Independent branches survive. |
| Parallel + orchestrator-gated | Independent branches in worktrees. Agent merges on Reviewer approval. Dependent branches queue. | Revert any merged PR. Independent branches unaffected. |

### What the Orchestrator does

Before any Construction work:

1. **Create GitHub issues** — one per planned branch. This is a MUST gate.
   No branch without an issue. No work without a ticket.
2. **Write the stack manifest** — `docs/branch-stacks/YYYY-MM-DD-slug.md`
   with branches, dependencies, parallel groups, acceptance criteria.
3. **Create branches** — named `feature/ISSUE-NNN-stack-N-short-description`
4. **Assign to execution mode**:
   - Sequential: Builder works one branch at a time
   - Parallel: independent branches fan out to worktrees

### Rollback protocol

At any point, the operator can:

- **Reject a PR** → branch is discarded. Dependents (per manifest) also discarded.
  Independent branches survive.
- **Reject the entire stack** → all branches discarded. Main is untouched
  (nothing merges until approved).
- **Revert a merged PR** → `git revert` the squash commit on main.
  Independent branches are unaffected because they based off main before
  the merge.

The stack manifest's dependency graph makes rollback mechanical:
look up what depends on the rejected branch, discard those too, keep
everything else.

### The non-negotiable

In ALL modes: **main is always deployable.** Nothing merges to main without:
1. `/verify` passing on the branch
2. Tests passing on the branch
3. PR opened (even if Reviewer is agent-gated, the PR exists for audit)
4. Spec and issue exist (MUST gates from Section 9)
