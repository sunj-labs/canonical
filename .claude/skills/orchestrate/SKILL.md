---
name: orchestrate
description: "Boot the Orchestrator at a process level (core/standard/full). Activates multi-agent SDLC with phase choreography, skill mapping, and iteration planning."
user_invocable: true
disable_model_invocation: false
---

# Orchestrate — Boot Multi-Agent SDLC Session

Invoke at any point to activate the Orchestrator and shift to a structured
multi-agent process level. This is the entry point for autonomous and
semi-autonomous development sessions.

## Usage

```
/orchestrate              → interactive: asks which level
/orchestrate standard     → boot at standard level
/orchestrate full         → boot at full level
/orchestrate dry-run      → boot sequence only, no work scheduled (validation mode)
```

## Process levels

| Level | What activates | Who orchestrates |
|-------|---------------|-----------------|
| `core` | Rules, hooks, skills, Builder + Reviewer. Light iteration planning. | Human |
| `standard` | + Architect, PM, Designer. Formal iteration bets. Phase gates active. | Human or Orchestrator agent |
| `full` | All 10 agents. Full ceremony. 4-signal iteration bet. All gates enforced. | Orchestrator agent |

## Procedure

### Step 1: Check for substrate.config.md

Read `substrate.config.md` in the repo root. If it doesn't exist, create one
interactively:

```markdown
# substrate.config.md

## Process
level: [ask operator: core / standard / full]

## Active agents
agents: [derived from level — see table below]

## Phases
phases: [Inception, Elaboration, Construction, Transition]

## Iteration planning
iterations: light | formal

## Risk register
risk-register: yes | no

## Budget
budget:
  session_ceiling: $20
  iteration_ceiling: [ASK OPERATOR — never assume]
  warning_threshold: 75%
```

Agent defaults by level:
- `core`: Builder, Reviewer
- `standard`: Shaper, PM, Designer, Architect, Builder, Reviewer
- `full`: Shaper, PM, Designer, Creative Director, Architect, Builder, Reviewer, Deployer, Closer, Orchestrator

### Step 2: Execute Orchestrator boot sequence

Follow `strategy/agent-choreography.md` Section 1 — all 8 steps:

1. **Read manifest** — substrate.config.md (created in step 1 if missing)
2. **Read phase state** — `docs/phase-state.md`. If missing, ask operator:
   - What phase are we in? (Inception if greenfield, Construction if app exists)
   - Create the file with current state
3. **Read iteration bet** — path from phase-state.md. If none exists:
   - At standard/full: prompt operator for iteration scope and appetite
   - At core: use light format (3-5 lines)
4. **Map skills to agents** — read all `.claude/skills/*/SKILL.md`, bind per
   `strategy/agent-choreography.md` Section 2
5. **Check risk register** — `docs/risk-register.md`. If missing and level
   requires it (standard/full), create with at least 3 initial risks
6. **Check session lock** — `.claude/SESSION_LOCK` per protocol
7. **Check for missing artifacts** — chronicles, architect reviews, danger summaries
8. **Propose work** — summarize phase, iteration, risks, and proposed agent
   activations. WAIT FOR OPERATOR CONFIRMATION.

### Step 3: Report boot status

Output a structured boot report:

```
## Orchestrator Boot Report

**Process level**: standard
**Phase**: Construction (iteration 2)
**Iteration bet**: docs/iteration-bets/2026-04-02-crm.md
**Appetite**: $8 / 30 turns

### Skill-agent bindings
[table of active skills → assigned agents]

### Risk register
[top 3 open risks]

### Missing artifacts
[any gaps found]

### Proposed work
[what the Orchestrator would schedule next]

### Boot status: READY / BLOCKED
[if blocked, list what needs to be resolved]
```

### Step 4: Activate (unless dry-run)

If not in dry-run mode and operator confirms:
- Begin phase choreography per `strategy/agent-choreography.md` Section 3
- Activate first agent(s) for the current phase
- The Orchestrator manages handoffs from here

If dry-run:
- Report only. Do not activate agents or start work.
- This validates the boot sequence works in the current environment.

## Dry-run mode

`/orchestrate dry-run` executes the full boot sequence but stops at the
report. Use this to:
- Validate the Orchestrator can boot in a new environment
- Check that substrate.config.md, phase-state, and iteration bet are correct
- Identify missing artifacts before starting real work
- Test after changes to the choreography or process framework

## Rules

- Never start work without operator confirmation (step 2.8)
- Never assume iteration_ceiling — always ask
- If any boot step fails, report it and stop. Don't skip steps.
- The Orchestrator coordinates but does not implement.
- At core level, this skill just creates/validates the manifest and reports
  status. The human drives from there.
