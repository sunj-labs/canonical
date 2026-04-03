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
/autonomous start        → scaffold missing artifacts + activate session
```

---

## /autonomous (default — about + readiness)

Show what autonomous development is, what levels exist, and how ready
this repo is right now.

### 1. Explain the three levels

| Level | What activates | Who drives | Best for |
|-------|---------------|-----------|----------|
| `core` | Rules, hooks, skills. Builder + Reviewer. Light iteration bets. | Human | Day-to-day supervised work |
| `standard` | + Architect, PM, Designer. Formal iteration bets. Phase gates. | Human or Orchestrator | Semi-autonomous: human sets direction, agents execute |
| `full` | All 10 agents. Full ceremony. 4-signal bets. All gates enforced. | Orchestrator agent | Fully autonomous: screenshots + intent in, PRs out |

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

Based on readiness, tell the operator what to do:
- "You're ready at core. To unlock standard, run `/autonomous start standard`."
- "You're ready at standard. To start an autonomous session, run `/autonomous start`."
- "Missing manifest — run `/autonomous start` to create one interactively."

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
  │   → Confirm budget: session_ceiling, iteration_ceiling (ALWAYS ASK)
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
  │   → Show: level, phase (from iteration bet), agents to activate,
  │     first action, appetite remaining
  │   → "Confirm to begin, or adjust."
  │   → WAIT FOR OPERATOR CONFIRMATION
  │
  └─ Step 9: ACTIVATE
      → Read the iteration bet's phase field
      → Select choreography from agent-choreography.md Section 3:
        - Inception → Shaper first (opus), then PM, then Creative Director
        - Elaboration → Architect + Designer (parallel if independent), then PM
        - Construction → Builder on stacked branches, Reviewer per PR
        - Transition → Deployer, then Creative Director spot-check, then Closer
      → Activation mechanics (how agents are invoked):
        - STANDARD level: spawn subagents via the Agent tool.
          The current session becomes the Orchestrator. It spawns each
          role agent as a subagent (e.g., Agent tool with
          subagent_type=Shaper). Human approves each handoff.
        - FULL level: same mechanics, but the Orchestrator chains
          through handoffs autonomously. Human reviews PRs, not
          handoffs.
        - If the iteration bet calls for multi-branch work:
          read standards/branch-stacking.md. Write a stack manifest.
          Sequential branches → one Builder subagent at a time.
          Parallel branches → multiple worktree agents (claude -w).
      → First agent receives:
        1. The iteration bet (scope, phase, appetite)
        2. The relevant substrate artifacts (canvas, spec, design docs)
        3. Any screenshots or intent provided by the operator
        4. The instruction: "Produce [artifact type] at [path]. Signal
           completion when done."
```

### Step-by-step detail

#### Step 1: Determine level

If level is provided as argument, use it. Otherwise ask:

> What process level?
> - **core** — I'll drive, agents assist (default for existing repos)
> - **standard** — I'll set direction, agents execute with phase gates
> - **full** — Agents run the full SDLC, I review PRs

#### Step 2: Scaffold — manifest

Read `substrate.config.md`. Three cases:

- **Missing**: Create interactively with the selected level.
- **Exists, same level**: No change needed. Confirm budget.
- **Exists, different level**: Update it. Specifically:
  - `level:` → new level
  - `agents:` → expanded agent list for new level
  - `iterations:` → `formal` if standard/full
  - `risk-register:` → `yes` if standard/full
  - Budget: confirm iteration_ceiling (ALWAYS ASK, never assume)

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
budget:
  session_ceiling: $20
  iteration_ceiling: [ASK — never assume a default]
  warning_threshold: 75%
```

#### Step 3: Scaffold — phase state

If `docs/phase-state.md` is missing, prompt:

> What phase is the overall project in?
> - **Inception** — greenfield, nothing built yet
> - **Elaboration** — architecture being proven
> - **Construction** — actively building and shipping
> - **Transition** — stabilizing for handoff/release

> What subsystems exist? What phase is each in?
> (e.g., "deal pipeline: Construction, CRM: not started, notifications: not started")

Create using template from `strategy/agent-choreography.md` Section 6.
The subsystem table allows different parts of the app to be at different
maturity levels.

#### Step 4: Scaffold — iteration bet

Prompt for each field. The iteration bet's `phase:` field determines which
choreography runs — it can differ from the project phase.

For **standard/full** (formal format):

> What are we building this iteration? (scope)
> What phase is THIS WORK in? (e.g., Inception for a new module)
> What risk are we retiring?
> What business value are we proving?
> What's the lovability signal? (would a user choose this?)
> What's the viability signal? (how do we measure success?)
> Cost ceiling? Turn limit?

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
- If found, seed risks from its findings
- Ask: "What are the top 3 risks to this project?"

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

Output the boot report. Then:

> **Boot status: READY at [level]**
>
> **Iteration**: [name] (phase: [from bet])
> **First action**: [what agent activates first, what it will produce]
> **Appetite**: $X / N turns
>
> Confirm to begin, or adjust.

**Wait for operator confirmation before activating any agents.**

#### Step 9: Activate

On confirmation, read the iteration bet's `phase:` field and activate the
corresponding choreography from `strategy/agent-choreography.md` Section 3.

**How agents are invoked:**

At **standard** level:
- The current session becomes the Orchestrator
- Each role agent is spawned as a subagent (via the Agent tool with the
  matching `subagent_type`, e.g., `Shaper`, `Builder`, `Architect`)
- The Orchestrator passes each subagent:
  1. The iteration bet (scope, phase, appetite)
  2. Relevant substrate artifacts (canvas, spec, design docs, screenshots)
  3. A clear instruction: "Produce [artifact] at [path]. Signal when done."
- Human approves each handoff between agents
- For multi-branch Construction work: write a stack manifest per
  `standards/branch-stacking.md`, then execute sequentially or in parallel

At **full** level:
- Same mechanics, but the Orchestrator chains through handoffs autonomously
- Human reviews PRs and phase gate results, not individual handoffs
- Parallel worktree agents (`claude -w`) for independent branches
- Orchestrator manages budget, appetite, and conflict detection

At **core** level:
- Report complete. Human drives from here.
- Skills and rules are active. Use `/temperance` before building, `/verify` after.
- The iteration bet and phase-state are reference artifacts for the human.

---

## Branch stacking (standard/full)

At standard and full levels, multi-step work uses stacked atomic branches
per `standards/branch-stacking.md`:

- Agent writes a **stack manifest** before building (branches, dependencies, parallel groups)
- **Sequential** (supervised): one branch at a time, human checkpoint between
- **Parallel** (Cherny worktree model): `claude -w` fans out independent branches
- Each branch is independently reviewable and revertable
- Graceful unwind: reject any branch without tangling the rest

---

## Rules

- Never start work without operator confirmation
- Never assume iteration_ceiling — always ask
- If any boot step fails at standard/full, scaffold the missing artifact before proceeding
- At core level, the human is the orchestrator — this skill just ensures the substrate is healthy
- The Orchestrator coordinates but does not implement
- Every autonomous session ends with `/chronicle` + memory update (session-end protocol)
