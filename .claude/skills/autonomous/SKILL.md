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

### Step 1: Determine level

If level is provided as argument, use it. Otherwise ask:

> What process level?
> - **core** — I'll drive, agents assist (default for existing repos)
> - **standard** — I'll set direction, agents execute with phase gates
> - **full** — Agents run the full SDLC, I review PRs

### Step 2: Scaffold missing artifacts

Check for each required artifact. If missing, create it interactively:

**substrate.config.md** (all levels):
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

**docs/phase-state.md** (standard/full — recommended for core):
- Ask: "What phase are we in?" (Inception if greenfield, Construction if app exists)
- Ask: "What iteration?" (1 if starting fresh)
- Create using template from `strategy/agent-choreography.md` Section 6

**Iteration bet** (standard/full — light format for core):
- Ask: "What are we building this iteration? What risk are we retiring?"
- For standard/full: prompt for all 4 signals (risk, value, lovability, viability)
- For core: light format (3-5 lines: retiring X, proving Y, ceiling $Z)
- Write to `docs/iteration-bets/YYYY-MM-DD-slug.md`

**docs/risk-register.md** (standard/full):
- Ask: "What are the top 3 risks to this project?"
- Seed with risks from the most recent architect review if available
- Format per `strategy/process-framework.md` Section 5

### Step 3: Execute boot sequence

Run the full 8-step boot from `strategy/agent-choreography.md` Section 1.
All artifacts should now exist (created in step 2 if missing).

### Step 4: Report + confirm

Output the boot report (same format as dry-run). Then:

> **Boot status: READY at [level]**
>
> Proposed first action: [what the Orchestrator would do]
>
> Confirm to begin, or adjust.

**Wait for operator confirmation before activating any agents or starting work.**

### Step 5: Activate

On confirmation:
- At **core**: Report complete. Human drives from here. Skills and rules are
  active. Use `/temperance` before building, `/verify` after.
- At **standard**: Begin phase choreography per `strategy/agent-choreography.md`
  Section 3. Activate first agent(s) for the current phase. Human approves
  each handoff.
- At **full**: Orchestrator takes over. Activates agents per phase choreography.
  Human reviews PRs, not sessions. Orchestrator manages handoffs, budget,
  and appetite autonomously.

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
