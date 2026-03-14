# Branching Strategy

## Model: Trunk-Based Development (Solo Variant)

One long-lived branch: `main`. It is always deployable.

## Branch Naming

```
feature/ISSUE-NNN-short-description
fix/ISSUE-NNN-short-description
spike/ISSUE-NNN-short-description
```

Every branch ties to a GitHub Issue. No branch without an issue.

## Flow

```
main ─────────────────────────────────────────
       \                    /
        feature/42-tool-reg  (PR, CI passes, squash merge)
```

1. Create issue
2. Create branch from `main`
3. Work on branch (commits don't need to be clean — they get squashed)
4. Open PR, link to issue
5. CI must pass (secret scan → lint → SAST → audit → test)
6. Squash merge to `main`
7. Delete branch

## Rules

- `main` is always deployable. Broken main = drop everything.
- No long-lived feature branches. If a branch lives > 5 days, it's too big. Break it up.
- Force push on feature branches is fine. Never on `main`.
- Squash merge keeps `main` history clean. One commit per PR.

## Tags and Releases

Semantic versioning: `v0.1.0`, `v0.2.0`, etc.

Tag on `main` when a milestone ships. GitHub Releases auto-generate notes from PR titles.
