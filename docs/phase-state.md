# Phase State

## Project-level phase
phase: Construction
note: Canonical is a methodology repo consumed by app repos (POA is first).
      Core standards and SDLC process are stable. Active work is extending
      skills, hardening autonomous infrastructure, and refining agent behavior.

## Active iteration
iteration_bet: docs/iteration-bets/2026-04-04-substrate-hardening.md
iteration_phase: Construction
branch_stack: (pending — will be created during Construction activation)

## Active agents
- Builder (Construction — implementing skills, standards, choreography changes)
- Reviewer (validating each commit)
- Architect (consulted on choreography changes)
- PM (viability signal — does this make autonomous runs trustworthy?)
- Designer (not active — no UI surfaces in this iteration)
- Shaper (not active — scope already shaped via iteration bet)

## Subsystem phases

| Subsystem | Phase | Last iteration | Notes |
|-----------|-------|---------------|-------|
| Standards (testing, security, commits, etc.) | Construction | 2026-04-03 | 7 standards, stable, incremental additions |
| Skills & agents | Construction | 2026-04-04 | 25 skills, 13 agents — active expansion |
| SDLC process & choreography | Construction | 2026-04-04 | Choreography, gates, handoffs — hardening |
| Autonomous infrastructure | Construction | 2026-04-04 | Current focus: trust, cost visibility, resilience |
| Session continuity | Construction | 2026-04-04 | Three-layer memory, hooks, session-end resilience |
| Design system & principles | Construction | 2026-04-04 | Luminaries, object model, engineering principles |

## Gate progress (project-level)
### Inception — COMPLETE (2026-03-14)
- [x] Vision doc (product canvas for canonical methodology)
- [x] Risk register populated
- [x] Appetite set
- [x] Viability hypothesis written
- [x] Build/buy/defer: BUILD

### Elaboration — COMPLETE (2026-03-19)
- [x] Architecture decisions (11 ADRs)
- [x] Standards defined (7 standards)
- [x] Design principles established
- [x] Object model documented (37 objects)

### Construction — IN PROGRESS
- [x] Standards: testing, security, commits, branching, diagnosis, usability, frontend-stack
- [x] Skills: 25 skills covering full SDLC
- [x] Agents: 13 agent definitions with luminaries
- [x] Choreography: full multi-agent protocol
- [x] Session continuity: three-layer memory + hooks
- [ ] Autonomous infrastructure: hardening (current iteration)
- [ ] Cost tracking and visibility
- [ ] Substrate self-test
- [ ] Session-end resilience

## Risk register
See docs/risk-register.md
