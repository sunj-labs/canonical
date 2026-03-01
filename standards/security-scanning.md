# Security Scanning Standard

Three layers. All run in CI via GitHub Actions, blocking merge on failure.

## Pipeline Order

```
push → secret scan → lint → SAST → dependency audit → test → build → deploy
       ^^^^^^^^^^^^                 ^^^^^^^^^^^^^^^^^
       Fail fast on                 Fail on known
       leaked creds                 vulnerabilities
```

## Layer 1: Secret Detection (pre-commit + CI)

**Tool:** gitleaks

**What it catches:** API keys, OAuth tokens, AWS credentials, passwords, private keys.

**Critical for:** Anthropic API keys, Gmail OAuth tokens, Apollo.io keys, AWS credentials, Brave Search API key.

**CI config:**
```yaml
- name: Detect secrets
  uses: gitleaks/gitleaks-action@v2
```

**Local pre-commit hook** (so secrets never reach the remote):
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

Install: `pip install pre-commit && pre-commit install`

## Layer 2: Dependency Vulnerabilities (CI)

**Tool:** pip-audit (Python), npm audit (Node)

**What it catches:** Known CVEs in installed packages.

```yaml
- name: Python dependency audit
  run: pip-audit --strict

- name: Node dependency audit  # if repo uses Node
  run: npm audit --audit-level=high
```

## Layer 3: Static Analysis / SAST (CI)

**Tool:** bandit (Python)

**What it catches:** SQL injection, hardcoded passwords, unsafe deserialization, shell injection.

```yaml
- name: Python security scan
  run: bandit -r src/ -ll -q
```

## Linting (separate from security, same pipeline)

**Tool:** ruff (Python)

```yaml
- name: Lint
  run: ruff check src/
```

## Adding to a New Repo

Each repo calls the org-level reusable workflow:

```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  ci:
    uses: sunj-labs/.github/.github/workflows/python-ci.yml@main
```

That's it. The reusable workflow handles the full pipeline.
