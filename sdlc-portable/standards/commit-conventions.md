# Commit Conventions

## Format: Conventional Commits

```
<type>: <description>

[optional body]

[optional footer: Closes #NNN]
```

## Types

| Type | When |
|------|------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code change that neither fixes nor adds |
| `test` | Adding or updating tests |
| `ci` | CI/CD pipeline changes |
| `chore` | Dependency updates, config, tooling |
| `security` | Security fix or scanning update |

## Rules

- Subject line: imperative mood, lowercase, no period, ≤72 chars.
- Body: wrap at 72 chars. Explain *why*, not *what* (the diff shows what).
- Footer: reference issues with `Closes #NNN` or `Ref #NNN`.

## Examples

```
feat: add tool registry for agent subsystems

Agents can now discover and invoke tools dynamically via
the registry instead of hardcoded imports. Tools register
with name, description, and callable.

Closes #42
```

```
fix: prevent PruneGuice from archiving starred emails

Safety rule check was running after the archive action
instead of before. Moved the check upstream.

Closes #67
```

## Squash Merge Convention

PR titles become the squash commit message. Write PR titles as conventional commits:

```
feat: add Brave Search tool to ETA agent (#73)
```
