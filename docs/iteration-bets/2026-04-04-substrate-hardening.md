## Iteration Bet: Substrate Hardening

**Phase**: Construction
**Subsystem**: Autonomous infrastructure (choreography, skills, hooks, standards)
**Primary luminary**: none — all luminaries equal (this is infrastructure, not UX)

**Scope**:
- 6 issues that improve operator trust and reduce autonomous session friction
- #59 Cost tracking per phase (operator visibility into spend)
- #46 Substrate self-test (validate wiring before autonomous runs)
- #56 Per-repo Google Doc ID (stops cross-contamination)
- #72 Prototype sprint unlock language (discoverability)
- #71 /autonomous UX refinements (reduce friction)
- #45 Session-end resilience (/session-end as skill, tiered obligations)

**Risk being retired**:
- R-TRUST: Can the operator trust that autonomous sessions are spending
  responsibly and producing artifacts in the right places? Cost tracking
  and self-test address this directly.

**Business value being proven**:
- An operator can run `/autonomous start`, see estimated cost before each
  phase, get actuals after, and trust that the substrate is correctly wired
  before agents activate.

**Lovability signal**:
- Would I run `/autonomous start full orchestrator-gated` overnight without
  anxiety? Cost visibility + self-test + resilient session-end = confidence.

**Viability signal**:
- Run `/autonomous dry-run` in POA after fixes ship. All 8 boot steps pass.
  Cost estimates appear at each phase boundary.

**Appetite**:
- Cost ceiling: $0 (sequential, human-gated, Max plan — this is docs/standards work)
- Turn limit: 60
- Warning threshold: 75%
