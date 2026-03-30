---
globs: ["*"]
description: Commit message format — Conventional Commits
---

Format: `<type>: <description>`

Types: feat, fix, docs, refactor, test, ci, chore, security

Rules:
- Imperative mood, lowercase, no period, max 72 chars
- Body: explain WHY not what — the diff shows what
- Footer: `Closes #NNN` or `Ref #NNN`
- PR titles become squash commit messages — make them clean
- One commit per PR on main (squash merge)
