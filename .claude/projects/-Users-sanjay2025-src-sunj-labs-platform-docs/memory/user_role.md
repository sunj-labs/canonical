---
name: user-role-and-goals
description: Sanjay is building an AI-native SDLC — wants autonomous multi-agent development across repos, with DORA metrics
type: user
---

Sanjay is the founder/builder at sunj-labs. Has a day job — needs agents that can work autonomously while he's away. Building a platform with multiple apps (POA is app 1, has a dozen more ideas).

Goals for this repo (platform-docs):
- Shared SDLC foundation that any app repo can import (extractable CLAUDE.md fragments, skills, hooks)
- AI-native development loop: reflect → plan → execute → measure
- DORA metrics tracking across all projects
- Multi-agent architecture: one human supervising multiple autonomous agents across multiple repos

Key context:
- POA repo is the active proving ground — has scheduled workers, GitHub Issues backlog, deployed to prod
- `ops` repo exists separately for operational runbooks (agentic-sdlc, session conventions, DORA tracking, GitHub Issues setup)
- `sdlc-portable/` in this repo is the reusable methodology kit
- Human reviews PRs, not sessions — that's the governance model for autonomous work
