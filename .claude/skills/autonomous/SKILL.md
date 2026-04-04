---
name: autonomous
description: "Autonomous development — about, readiness check, dry-run, or start an autonomous session. Entry point for multi-agent SDLC."
user_invocable: true
disable_model_invocation: false
---

# Autonomous Development

Entry point for autonomous and semi-autonomous development sessions.
Invoke at any point in any repo that inherits canonical.

## Usage

```
/autonomous              → about + current readiness (default)
/autonomous dry-run      → full boot sequence validation, read-only
/autonomous start        → scaffold + activate (asks for choices below)
```

### Three choices at boot

The agent asks these during Step 1. All three are independent axes.

**1. Agent level** — which agents are active:

| Level | Agents active | When to use |
|-------|--------------|-------------|
| `core` | Builder, Reviewer | Day-to-day supervised work |
| `standard` | + Shaper, PM, Designer, Architect (6 agents) | Structured iterations with shaping + design |
| `full` | All 10 agents including Creative Director, Deployer, Closer, Orchestrator | Full ceremony, production releases |

**2. Execution mode** — how work is performed:

| Mode | What happens | Burst cost | Best for |
|------|-------------|-----------|----------|
| **sequential** (default) | One session plays all roles in order. Persona switches, not subagent spawns. | $0 (Pro plan) | Overnight runs, budget-conscious, simpler debugging |
| **parallel** (opt-in) | Orchestrator spawns subagents per role. Independent work fans out to worktrees. | Burst tokens | Throughput, multi-branch parallel work |

**3. Gating** — who approves handoffs between roles:

| Gating | What happens | Best for |
|--------|-------------|----------|
| **human-gated** | Agent pauses between phases/roles for human approval | Daytime supervised sessions, learning the system |
| **orchestrator-gated** | Agent chains through phases autonomously, no pauses | Overnight runs, trusted workflows |

### Combinations

Any mix works. Examples:

| You want... | Configuration |
|-------------|--------------|
| Supervised daytime session | standard, sequential, human-gated |
| Overnight build, zero burst | full, sequential, orchestrator-gated |
| Fast parallel build, human review | standard, parallel, human-gated |
| Fully autonomous, max throughput | full, parallel, orchestrator-gated |

Default is **sequential + human-gated**. The agent asks if you want
parallel (explains burst cost) and orchestrator gating (explains what
it means to let the agent chain without pausing).

**How sequential mode works:**
- One continuous session (interactive or headless via `claude -p`)
- The agent reads the choreography and plays each role in order
- Between roles, it writes the handoff artifact, then switches persona
  (e.g., "I am now acting as Architect" → reads Architect agent definition
  → produces ADRs → writes handoff → "I am now acting as Builder")
- If human-gated: pauses between phases for approval
- If orchestrator-gated: chains through all phases without pausing

---

## /autonomous (default — about + readiness)

Show what autonomous development is, what levels exist, and how ready
this repo is right now.

### 1. Explain the three axes

**Agent level** — which agents are active:

| Level | Agents | What's different |
|-------|--------|-----------------|
| `core` | Builder, Reviewer (2) | Light iteration bets. Human drives. |
| `standard` | + Shaper, PM, Designer, Architect (6) | Formal bets. Phase gates. Shaping + design. |
| `full` | + Creative Director, Deployer, Closer, Orchestrator (10) | Full ceremony. Production releases. |

**Execution mode** — how work runs (default: sequential):

| Mode | Burst cost | How it works |
|------|-----------|-------------|
| sequential | $0 (Pro plan) | One session, persona switches between roles |
| parallel | Burst tokens | Subagents spawned per role, worktrees for branches |

**Gating** — who approves handoffs (default: human-gated):

| Gating | When to use |
|--------|-----------|
| human-gated | Daytime sessions, learning the system, steering |
| orchestrator-gated | Overnight runs, trusted workflows |

### 2. Quick readiness check

Scan the repo for the key artifacts and report status:

```
## Readiness

| Artifact | Status | Path |
|----------|--------|------|
| Manifest (substrate.config.md) | ✅ Found / ❌ Missing | ... |
| Phase state (docs/phase-state.md) | ✅ / ❌ | ... |
| Iteration bet | ✅ / ❌ | ... |
| Risk register (docs/risk-register.md) | ✅ / ❌ / ⚠️ Disabled | ... |
| Skills | ✅ N skills found | .claude/skills/ |
| Session lock | ✅ Clear / ⚠️ Active | ... |
| Chronicle (current) | ✅ / ⚠️ Stale (N commits behind) | ... |

Current level: core
Ready for: core ✅ | standard ⚠️ (needs: phase-state, iteration bet, risk register) | full ❌
```

### 3. Show next steps

**MUST gates apply at ALL levels** (core, standard, full):
/temperance before building, /verify after, /diagnose before fixing,
tests with code, chronicle at phase transitions. These are not optional
at any level. The level choice controls which agents are active, not
which gates fire.

Based on readiness, tell the operator what to do. Use the AskUserQuestion
tool to offer numbered choices — don't make them type commands:
1. "Stay at core — you drive, substrate assists"
2. "Upgrade to standard — structured iterations with shaping + design"
3. "Upgrade to full — complete ceremony with all 10 agents"

Note: stale artifacts (overdue chronicles, architect reviews) will be
resolved automatically during the `/autonomous start` boot sequence.
Don't present them as blockers — say "resolved during boot."

---

## /autonomous dry-run

Full Orchestrator boot sequence, read-only. No files created, no agents
activated. Use this to validate the boot works in the current environment.

### Procedure

Spawn the Orchestrator agent (or execute inline) to run all 8 boot steps
from `strategy/agent-choreography.md` Section 1:

1. **Read manifest** — `substrate.config.md`
2. **Read phase state** — `docs/phase-state.md`
3. **Read iteration bet** — path from phase-state
4. **Map skills to agents** — read all `.claude/skills/*/SKILL.md`, bind per
   `strategy/agent-choreography.md` Section 2
5. **Check risk register** — `docs/risk-register.md`
6. **Check session lock** — `.claude/SESSION_LOCK`
7. **Check for missing artifacts** — chronicles, architect reviews, danger summaries
8. **Propose work** — what would the Orchestrator schedule?

For each step report: **PASS / FAIL / WARN** with details.

### Output

```
## Dry-Run Boot Report

**Process level**: [from manifest]
**Phase**: [from phase-state]
**Date**: YYYY-MM-DD

### Boot checklist
| Step | Status | Detail |
|------|--------|--------|
| 1. Manifest | ✅ | core level, budget $20/$8 |
| 2. Phase state | ❌ | File missing |
| ... | ... | ... |

### Skill-agent bindings
[N skills mapped to M agents]

### Top risks
[from risk register, or "no register found"]

### Missing artifacts
[chronicles, reviews, summaries that are overdue]

### Would propose
[what work the Orchestrator would schedule]

### Boot status: READY / BLOCKED
[blockers listed if any]
```

**Rules**: Read-only. Do not create, modify, or delete any files.

---

## /autonomous start [level]

Scaffold missing artifacts and boot the Orchestrator at the requested level.
This is where autonomous work begins.

### The full chain

```
/autonomous start standard
  │
  ├─ Step 1: DETERMINE LEVEL
  │   → From argument, or ask operator
  │
  ├─ Step 2: SCAFFOLD — manifest
  │   → If substrate.config.md MISSING → create interactively
  │   → If EXISTS but level DIFFERS from requested → UPDATE it
  │     (upgrade agents list, iterations format, risk-register flag)
  │   → Confirm budget: iteration_ceiling (ALWAYS ASK)
  │     (burst pool, not Pro plan — explain the difference)
  │
  ├─ Step 3: SCAFFOLD — phase state
  │   → If docs/phase-state.md MISSING → create interactively:
  │     "What phase is the overall project in?"
  │     "What subsystems exist and what phase is each in?"
  │   → If EXISTS → read and confirm current state
  │
  ├─ Step 4: SCAFFOLD — iteration bet
  │   → Prompt for all fields (format depends on level):
  │     - What are we building? (scope)
  │     - What phase is THIS WORK in? (can differ from project phase)
  │     - What risk are we retiring?
  │     - What value are we proving?
  │     - Lovability signal? (standard/full only)
  │     - Viability signal? (standard/full only)
  │     - Appetite: cost ceiling + turn limit
  │   → Write to docs/iteration-bets/YYYY-MM-DD-slug.md
  │   → Update phase-state.md to point at this bet
  │
  ├─ Step 5: SCAFFOLD — risk register
  │   → If docs/risk-register.md MISSING and level requires it →
  │     Seed from most recent architect review if available
  │     Ask: "What are the top 3 risks?"
  │     Create file per process-framework.md Section 5
  │   → If EXISTS → read, surface top open risks
  │
  ├─ Step 6: RESOLVE STALE ARTIFACTS
  │   → Check chronicles: commits since last entry?
  │     If ≥3 commits behind → WRITE THE MISSING CHRONICLE NOW
  │     (This is not optional — next agents need session context)
  │   → Check architect review: ≥10 commits since last?
  │     If yes → schedule architect review as first task
  │   → Check danger mode summaries: any missing?
  │
  ├─ Step 7: EXECUTE 8-STEP BOOT
  │   → All artifacts now exist. Run the full boot sequence from
  │     strategy/agent-choreography.md Section 1.
  │   → Every step should PASS. If any FAIL → stop and fix.
  │   → Read iteration bet phase → this determines which choreography runs
  │
  ├─ Step 8: REPORT + CONFIRM
  │   → Output boot report (same format as dry-run)
  │   → Show the PERSONALIZED EXECUTION CHAIN for this directory:
  │     "Here's what will happen in [repo name], in this order:"
  │     1. [Agent] will produce [artifact] at [actual path in this repo]
  │     2. [Agent] will produce [artifact] at [actual path]
  │     3. ... (full chain based on phase + level + active agents)
  │     MUST gates that will fire: [list from choreography Section 9]
  │     Checkpoints: after each step above
  │     Gating: [human/orchestrator] — where pauses happen
  │     Estimated artifacts: N files across M directories
  │   → Show: level, execution mode, gating, phase (from bet),
  │     appetite remaining
  │   → "Confirm to begin, or adjust."
  │   → WAIT FOR OPERATOR CONFIRMATION
  │
  └─ Step 9: ACTIVATE
      → Read the iteration bet's phase field
      → Select choreography from agent-choreography.md Section 3:
        - Inception → Shaper first, then PM, then Creative Director
        - Elaboration → Architect + Designer, then PM
        - Construction → Builder on stacked branches, Reviewer per PR
        - Transition → Deployer, Creative Director spot-check, Closer
      → Execution mode determines HOW:
        SEQUENTIAL (default):
          One session plays all roles in order. Between roles:
          1. Write the handoff artifact to its known path
          2. Switch persona: read the next agent's definition from
             ~/.claude/agents/{role}.md
          3. State: "Now acting as [Role]. Reading [artifact]."
          4. Execute that role's choreography steps
          5. Repeat until phase complete
          At standard: pause between phases for human approval
          At full: chain through all phases without pausing
          Burst cost: $0 (all Pro plan usage)
        PARALLEL (opt-in with 'parallel' flag):
          Orchestrator spawns subagents via the Agent tool.
          Each role agent is a subagent with subagent_type matching
          the role (e.g., Shaper, Builder, Architect).
          At standard: human approves each handoff
          At full: Orchestrator chains autonomously
          Multi-branch work: worktree agents (claude -w) for
          independent branches per standards/branch-stacking.md
          Burst cost: tokens per subagent spawn
      → First role receives:
        1. The iteration bet (scope, phase, appetite)
        2. The relevant substrate artifacts (canvas, spec, design docs)
        3. Any screenshots or intent provided by the operator
        4. The instruction: "Produce [artifact type] at [path]."
```

### CRITICAL EXECUTION RULES

1. **Steps are SEQUENTIAL EXCHANGES, not a single prompt wall.**
   Each step (2 through 6) is its own turn. Ask, wait for answer,
   process the answer, then move to the next step. Do NOT present
   all questions at once.

2. **Present prompts VERBATIM from this document.**
   The parenthetical explanations are carefully written for the operator.
   Do NOT summarize, compress, or rephrase them. Copy them exactly.
   If you are tempted to summarize a prompt into a one-liner, STOP.
   The full explanation exists because operators need context to give
   good answers. A compressed prompt produces compressed answers.
   
   Use the **AskUserQuestion tool** for structured choices (level,
   execution mode, gating) instead of free-text. For open-ended
   questions (scope, risk, value), present the full prompt with
   examples and let the operator type freely.

3. **WAIT FOR CONFIRMATION between steps.**
   After scaffolding each artifact, show what was created and ask
   "Does this look right?" before moving to the next step.

4. **Context-aware examples.**
   When the repo is under active development (has commits, issues,
   existing code), tailor examples to what exists:
   - Read existing Prisma schema, routes, or components to understand
     the domain vocabulary
   - Reference existing GitHub issues by number
   - Use actual entity names from the codebase in examples
   - For a greenfield repo, use the generic examples from this document
   This makes the prompts feel like a conversation with someone who
   knows the project, not a generic template.

### Step-by-step detail

#### Step 1: Determine level, execution mode, and gating

Use the AskUserQuestion tool to ask these. Do NOT collapse into free-text.

Defaults: **sequential** execution + **human-gated**. These are assumed
unless the operator explicitly changes them. Only ask about level — then
state the defaults and offer to change:

> **What agent level?**
> - **core** — Builder + Reviewer only. You drive everything else.
> - **standard** — + Shaper, PM, Designer, Architect (6 agents). Structured
>   iterations with shaping and design phases.
> - **full** — All 10 agents including Creative Director, Deployer, Closer,
>   Orchestrator. Full ceremony for production-quality work.

After level is chosen, use AskUserQuestion to confirm execution mode and gating:

> **Execution mode?** (default: sequential)
> 1. **sequential** (default) — One session, persona switches. $0 burst cost.
> 2. **parallel** — Subagents per role, worktrees for branches. Costs burst tokens.

> **Gating?** (default: human-gated)
> 1. **human-gated** (default) — Pauses between phases for your approval.
> 2. **orchestrator-gated** — Chains through all phases without pausing. Review PRs after.

If the operator selects **orchestrator-gated**, check and advise:

> Orchestrator-gated mode runs without pausing for approval. This requires
> `--dangerously-skip-permissions` so the agent can write files, commit,
> and run commands without prompting.
>
> If this session wasn't started with that flag, you'll need to exit and
> restart: `claude --dangerously-skip-permissions`
>
> A danger mode summary will be written at session end documenting all
> autonomous decisions made.

#### Step 2: Scaffold — manifest

Read `substrate.config.md`. Three cases:

- **Missing**: Create interactively with the selected level.
- **Exists, same level**: No change needed. Confirm iteration_ceiling.
- **Exists, different level**: Update it. Specifically:
  - `level:` → new level
  - `agents:` → expanded agent list for new level
  - `iterations:` → `formal` if standard/full
  - `risk-register:` → `yes` if standard/full
  - Budget: confirm iteration_ceiling (ALWAYS ASK, never assume)

When confirming budget, explain the distinction:
> Your Max plan covers all interactive Claude Code usage. The budget here
> governs the **API burst pool** — a separate $25 pool that's consumed when
> the Orchestrator spawns subagents or runs headless agents. It replenishes
> when it drops to $10. The session ceiling ($20) leaves a $5 buffer.
> How much burst budget for this iteration?

```markdown
# substrate.config.md

## Process
level: [selected level]

## Active agents
agents: [derived from level]
# core: Builder, Reviewer
# standard: Shaper, PM, Designer, Architect, Builder, Reviewer
# full: all 10

## Phases
phases: [Inception, Elaboration, Construction, Transition]

## Iteration planning
iterations: [light (core) | formal (standard/full)]

## Risk register
risk-register: [no (core) | yes (standard/full)]

## Budget
#
# Context: The Max plan ($100/month) covers all interactive Pro usage
# (conversations in Claude Code). The budget below governs API burst
# usage — tokens consumed when the Orchestrator spawns subagents,
# runs headless agents (claude -p), or fans out worktree agents.
#
# At core level (human driving, no subagent spawning), burst usage
# is typically zero. At standard/full, each subagent spawn may
# consume API tokens outside the Pro plan.
#
# The API burst pool ($25) replenishes when it drops to $10.
# session_ceiling should leave a safety margin (never touch last $5).
#
budget:
  session_ceiling: $20         # max API burst per session (leave $5 buffer)
  iteration_ceiling: [ASK]     # max burst per iteration (never assume)
  warning_threshold: 75%       # Orchestrator surfaces status at this %
```

#### Step 3: Scaffold — phase state

If `docs/phase-state.md` is missing, prompt:

> **What phase is the overall project in?**
> (This is the project as a whole, not any individual feature.
> - **Inception** — greenfield, nothing built yet, still deciding what to build
> - **Elaboration** — committed to building, proving the architecture works
> - **Construction** — actively building and shipping features
> - **Transition** — built, stabilizing for handoff or public release
> Most existing apps with users are in Construction.)
>
> **What subsystems exist? What phase is each in?**
> (List the major functional areas of your app and their maturity.
> This lets the agent run different choreography for different parts.
> Example: "deal pipeline: Construction, scoring: Construction,
> communications: Construction, CRM: not started, notifications: not started"
> Subsystems with no work yet can be listed as "not started.")

Create using template from `strategy/agent-choreography.md` Section 6.
The subsystem table allows different parts of the app to be at different
maturity levels.

**WAIT FOR CONFIRMATION.** Show the subsystem table and ask: "Does this
look right? Adjust any phases before we continue." The iteration bet's
phase depends on the subsystem classification — get this right first.

#### Step 4: Scaffold — iteration bet

Prompt for each field. The iteration bet's `phase:` field determines which
choreography runs — it can differ from the project phase.

For **standard/full** (formal format), prompt with explanations:

> **What are we building this iteration?**
> (One or two sentences describing the scope. Example: "CRM module for
> tracking broker contacts and interaction history alongside deal flow."
> This becomes the iteration's scope definition — be specific enough that
> an agent could build it without asking follow-up questions.)
>
> **What phase is THIS WORK in?**
> (The phase of this specific subsystem, not the overall project.
> - Inception = new idea, no artifacts yet, needs a canvas and shaping
> - Elaboration = idea is validated, architecture needs proving
> - Construction = architecture proven, ready to build and ship
> - Transition = built, needs deployment/stabilization/handoff
> Example: "Inception — CRM is a new module, nothing exists yet.")
>
> **What risk are we retiring?**
> (The single biggest thing that could kill this if we don't address it
> this iteration. Format: one sentence starting with "Can we..." or
> "Will...". Example: "Can we model CRM relationships without breaking
> the existing deal pipeline schema?")
>
> **What business value are we proving?**
> (What outcome makes this worth building? Not a feature description —
> the business result. Example: "Operator can track broker interactions
> in the same tool as deal flow, eliminating the spreadsheet.")
>
> **What's the lovability signal?**
> (How would you know a user actually wants this? Not "it works" but
> "they'd choose it." Example: "Would I open this instead of my
> spreadsheet when a broker calls?")
>
> **What's the viability signal?**
> (A measurable outcome or observable behavior. Example: "Time from
> broker contact to logged interaction drops below 2 minutes." This is
> what the PM watches to know if the iteration proved its value.)
>
> **Turn limit?**
> (The cost ceiling was already set in the manifest (Step 2). The turn
> limit is the remaining piece.
>
> Based on your configuration, here's my recommendation:
>
> **Cost ceiling**: already set to $[read from manifest]. Sequential mode
> = $0 burst (Max plan covers everything). Parallel mode = burst tokens
> per subagent spawn.
>
> **Recommended turn limit** based on phase and execution mode:
> - Inception (artifacts, not code): 50 turns
> - Elaboration (ADRs, design, prototypes): 40 turns
> - Construction (code, tests, PRs): 30 turns per branch stack
> - Transition (deploy, release notes, retro): 20 turns
>
> The agent will scope DOWN to fit — fixed budget, variable scope.
>
> Accept the recommendation, or enter a custom turn limit.)
>
> **Any reference material?** (optional)
> (Screenshots, mockups, prior art, inspiration — anything the Shaper
> should look at when developing the canvas. Provide file paths or URLs.
> Example: "~/Downloads/crm-inspiration" or "see POA issue #260")

Write to `docs/iteration-bets/YYYY-MM-DD-slug.md`:

```markdown
## Iteration Bet: [name]

**Phase**: [from answer — this drives choreography]
**Subsystem**: [which part of the app]

**Scope**:
- [what's being built]

**Risk being retired**:
- R-NNN: [description] — how this iteration resolves it

**Business value being proven**:
- [outcome]: [how we'll know]

**Lovability signal**:
- [what Designer validates]

**Viability signal**:
- [what PM watches — metric or behavior]

**Appetite**:
- Cost ceiling: $X
- Turn limit: N
- Warning threshold: 75%

**Reference material** (optional):
- [screenshots, mockups, prior art — file paths or URLs]
```

For **core** (light format):

```markdown
## Iteration: [name]
Retiring: [one line]
Proving: [one line]
Scope: [features]
Cost ceiling: $X
Turn limit: N
```

Update `docs/phase-state.md` to point at the new bet.

#### Step 5: Scaffold — risk register

If `docs/risk-register.md` is missing and level requires it (standard/full):

- Check for most recent architect review in `docs/architecture/reviews/`
- If found, seed risks from its findings and present them:
  "I found these risks in the latest architect review: [list].
  Do these still apply? Any to add or remove?"
- If no review found, ask:

> **What are the top 3 risks to this project?**
> (Things that could kill the project or this iteration if not addressed.
> Each risk has a type: Tech (can we build it?), Market (will anyone want it?),
> UX (will it be usable?), or Ops (can we run it?).
> Example: "Tech: CRM schema migration could break existing deal queries.
> Market: broker tracking may not be valuable enough to justify the complexity.
> UX: if logging an interaction takes more than 30 seconds, nobody will do it.")

```markdown
## Risk Register

| ID | Description | Type | Likelihood | Impact | Phase ID'd | Mitigation | Status |
|----|-------------|------|-----------|--------|-----------|------------|--------|
| R-001 | ... | Tech/Market/UX/Ops | H/M/L | H/M/L | ... | ... | open |
```

#### Step 6: Resolve stale artifacts

Before booting, clean up debt from previous sessions:

- **Chronicle**: If ≥3 commits since last entry → write the missing chronicle
  NOW. Do not defer. The next agents need session context to understand
  what happened before them.
- **Architect review**: If ≥10 commits since last → schedule as first task
  after boot (does not block boot, but is first work item).
- **Danger mode summaries**: If auto-complete was used without a summary →
  note in boot report for operator to address.

#### Step 7: Execute 8-step boot

All artifacts now exist (created or updated in steps 2-6). Run the full
boot sequence from `strategy/agent-choreography.md` Section 1. Every step
should PASS. If any FAIL → stop, report, fix before continuing.

#### Step 8: Report + confirm

Output the boot report WITH a personalized execution chain for this
directory. The operator must see exactly what will happen before confirming.

> **Boot status: READY**
>
> **Configuration**: [level] / [sequential|parallel] / [human|orchestrator]-gated
> **Iteration**: [name] (phase: [from bet], subsystem: [name])
> **Appetite**: $X / N turns
>
> **Execution chain for [repo name]:**
>
> | Step | Agent | Produces | Path | MUST gates |
> |------|-------|----------|------|-----------|
> | 1 | Shaper | Product canvas (Thesis) | docs/strategy/canvases/... | /temperance |
> | 2 | Shaper | Risk register | docs/risk-register.md | — |
> | 3 | PM | Viability hypothesis | in canvas | — |
> | 4 | PM | Iteration bet (Construction) | docs/iteration-bets/... | — |
> | ⏸ | — | **Human checkpoint** (if human-gated) | — | — |
> | 5 | Architect | C4 diagrams | docs/architecture/c4/... | /temperance |
> | 6 | Architect | ADRs | docs/architecture/decisions/... | ADR compliance |
> | ... | ... | ... | ... | ... |
>
> **Checkpoints**: After every step above (phase-state updated, artifact committed)
> **MUST gates that will fire**: /temperance, /verify, /diagnose (on failure), tests, chronicle
> **Estimated output**: ~N artifacts across M directories
>
> Confirm to begin, or adjust.

The chain must be built from:
1. The iteration bet's phase → which choreography from Section 3
2. The agent level → which agents are active
3. The repo's actual directory structure → real paths, not templates
4. The MUST gates from choreography Section 9

**Wait for operator confirmation before activating any agents.**

#### Step 9: Activate

On confirmation, read the iteration bet's `phase:` field and activate the
corresponding choreography from `strategy/agent-choreography.md` Section 3.

**Sequential mode (default):**

One session plays all roles. No subagent spawning. Zero burst cost.

The agent walks through the choreography in order. Between each role:
1. Write the handoff artifact to its known path (per Section 4 of choreography)
2. Read the next agent's definition from `~/.claude/agents/{role}.md`
3. State: "Now acting as [Role]. Reading [handoff artifact]."
4. Execute that role's steps from the choreography
5. Write output artifact, then switch to next role

For multi-branch Construction work in sequential mode: the agent writes a
stack manifest, then builds one branch at a time (no worktree parallelism).

**Parallel mode:**

Orchestrator spawns subagents. Each role is a separate agent invocation.

- The current session becomes the Orchestrator
- Each role agent is spawned as a subagent (via the Agent tool with the
  matching `subagent_type`, e.g., `Shaper`, `Builder`, `Architect`)
- The Orchestrator passes each subagent:
  1. The iteration bet (scope, phase, appetite)
  2. Relevant substrate artifacts (canvas, spec, design docs, screenshots)
  3. A clear instruction: "Produce [artifact] at [path]. Signal when done."
- Multi-branch work: worktree agents (`claude -w`) for independent branches
- Orchestrator manages budget, appetite, and conflict detection
- Burst cost: each subagent spawn consumes API burst tokens

**Gating (applies to both execution modes):**

- **Human-gated**: Agent pauses between phases for approval.
  "Phase [X] complete. Artifacts produced: [list]. Ready to begin [Y]. Confirm?"
  Best for daytime sessions where you want to steer.
- **Orchestrator-gated**: Agent chains through all phases without pausing.
  Human reviews output (PRs, artifacts) after session completes.
  Ideal for overnight — start it, sleep, review PRs in the morning.

**At core level** (either mode, either gating):
- Report complete. Human drives from here.
- Skills and rules are active. Use `/temperance` before building, `/verify` after.
- The iteration bet and phase-state are reference artifacts for the human.

---

## Pre-build gates (MUST — enforced before any Construction work)

Before any code is written, the Orchestrator (or the agent in sequential
mode) MUST ensure:

1. **Spec exists** — a spec (from `/spec` or `/canvas` Stage 2+) must exist
   and be referenced by the iteration bet. No code without a spec.
2. **GitHub issues exist** — one per planned branch/task. No branch without
   an issue. No work without a ticket.
3. **Stack manifest written** — `docs/branch-stacks/YYYY-MM-DD-slug.md`
   with branches, dependencies, parallel groups, acceptance criteria.
4. **Branches created** — named `feature/ISSUE-NNN-stack-N-short-description`

These are not suggestions. They are MUST gates per `strategy/agent-choreography.md`
Section 9. If any is missing, the agent stops and scaffolds it before proceeding.

## Branch stacking (all modes)

Every autonomous mode uses stacked atomic branches per `standards/branch-stacking.md`.
The constant: **every branch is independently revertable.**

| Mode + Gating | Branching | Rollback |
|---------------|-----------|----------|
| Sequential + human-gated | One branch at a time. PR reviewed before next starts. | Drop any PR. Zero tangling. |
| Sequential + orchestrator-gated | One branch at a time, chained. PRs opened but not merged until human reviews. | Reject any PR. Dependents discarded per manifest. |
| Parallel + human-gated | Independent branches in worktrees. Human reviews each. | Drop any PR. Independent branches survive. |
| Parallel + orchestrator-gated | Worktree branches. Agent merges on Reviewer approval. | Revert any merged PR. Independent unaffected. |

**Rollback at any point**: reject a PR (dependents discarded, independents survive),
reject the entire stack (main untouched), or revert a merged PR (git revert the squash).

See `strategy/agent-choreography.md` Section 12 for full branching protocol.

---

## Context management (critical for unattended runs)

Long-running sequential sessions WILL hit context limits. The strategy:

**Parallel mode**: not a problem. Each subagent has fresh context. Use
this for large builds where context pressure is a concern.

**Sequential mode**: active management required.
- At each role transition: checkpoint, commit, let compaction run
- After compaction: re-read the **survival kit** (6 files):
  1. Iteration bet
  2. Current spec
  3. MUST gates (choreography Section 9)
  4. Phase-state
  5. Branch stack manifest (if in Construction)
  6. Current agent definition
- At 70% context: checkpoint immediately, compaction will free space
- At 90%: complete current atomic task, checkpoint, re-read survival kit

See `strategy/agent-choreography.md` Section 12a for full protocol.

## Transition hierarchy — when artifacts fire

Every handoff is a transition. Artifacts fire based on the level:

**Role handoff** (Shaper → PM, Builder → Reviewer, etc.):
- MUST: checkpoint + commit artifact + update phase-state
- SHOULD: LinkedIn draft if the handoff produced a notable decision or
  insight. The best posts come from thinking phases, not building.

**Phase transition** (Inception → Elaboration, etc.):
- MUST: everything above + **chronicle entry** capturing what the phase
  produced, decisions made, open threads
- SHOULD: LinkedIn draft — phase transitions are natural post boundaries

**Iteration complete** (through Transition phase):
- MUST: everything above + retro + memory update
- SHOULD: LinkedIn post (polished from drafts accumulated during handoffs)
- MAY: release notes (if deployed)

Chronicles fire at **every phase transition**, not just at the end. If the
agent completes Inception and moves to Elaboration, that's a chronicle.
If the session dies during Elaboration, the Inception chronicle exists.

See `strategy/agent-choreography.md` Section 12a for full protocol.

## Rules

- Never start work without operator confirmation
- Never assume iteration_ceiling — always ask
- If any boot step fails at standard/full, scaffold the missing artifact before proceeding
- At core level, the human is the orchestrator — this skill just ensures the substrate is healthy
- The Orchestrator coordinates but does not implement
- Spec and issues MUST exist before any Construction branch is created
- Every autonomous session ends with `/chronicle` + memory update
