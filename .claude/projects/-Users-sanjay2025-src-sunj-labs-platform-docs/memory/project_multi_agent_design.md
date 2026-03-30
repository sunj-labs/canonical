---
name: multi-agent-architecture-design
description: Open design conversation — scaling from single-agent to autonomous multi-agent multi-repo development
type: project
---

Core question: How to go from "one human + one agent in one repo" to "one human supervising multiple agents across multiple repos, some running autonomously"?

**Why:** Sanjay has a day job and a dozen app ideas. Single-session throughput isn't the bottleneck — he needs work happening while he's away.

**Key design tensions (unresolved as of 2026-03-24):**
- Autonomy vs safety — unsupervised agents need harder gates than supervised ones
- Shared standards vs app-specific context — SDLC skills/hooks currently embedded per-repo, need to be extractable
- Merge governance — parallel agents on same repo will conflict; PR-based output is the proposed model
- Cost control — autonomous agents burning API credits while human is away

**Proposed architecture direction:**
- platform-docs/ = shared SDLC, skills, hooks, standards (importable)
- Each app's CLAUDE.md imports from platform-docs rather than defining its own process
- Agents scheduled via Claude Code triggers or GitHub Actions
- Human reviews PRs, not sessions

**How to apply:** Next session should produce a proper canvas (product-canvas.md style) for this initiative before building anything. This is a design conversation, not implementation yet.
