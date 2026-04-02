---
globs: ["*"]
description: Trunk-based development — branch naming and flow
---

Model: trunk-based development (solo variant). `main` is always deployable.

Branch naming:
- `feature/ISSUE-NNN-short-description`
- `fix/ISSUE-NNN-short-description`
- `spike/ISSUE-NNN-short-description`

Every branch ties to a GitHub Issue. No branch without an issue.

Flow: issue → branch from main → work → PR → CI passes → squash merge → delete branch

Rules:
- Broken main = drop everything
- No branches older than 5 days — break it up
- Force push on feature branches is fine, never on main
- Semantic versioning tags for releases: v0.1.0, v0.2.0

Multi-branch work (autonomous/multi-step sessions):
- See `standards/branch-stacking.md` for stacked atomic branches
- Stack manifest declares branches, dependencies, parallel-safety
- Naming: `feature/ISSUE-NNN-stack-N-short-description`
- Each branch is independently reviewable and revertable
