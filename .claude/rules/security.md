---
globs: ["**/*.ts", "**/*.tsx", "**/*.json", ".env*", "Dockerfile*", "docker-compose*"]
description: Security scanning — loads when touching source, config, or infra files
---

Three-layer security pipeline. All block merge on failure.

Pipeline order: push → secret scan → lint → typecheck → SAST → dependency audit → test → build → deploy

Layer 1 — Secret Detection (gitleaks):
  Pre-commit hook + CI. Catches API keys, OAuth tokens, AWS creds, private keys.
  Never commit .env files, credentials, or API keys.

Layer 2 — Dependency Vulnerabilities (npm audit):
  CI blocks on high-severity CVEs. Uses audit-ci for strict enforcement.

Layer 3 — SAST (ESLint security plugins + TypeScript compiler):
  eslint-plugin-security, @typescript-eslint, eslint-plugin-no-secrets.
  Optional: Semgrep for deeper analysis as complexity grows.

Rules:
- No secrets in code or logs — use environment variables
- Validate all user input at system boundaries
- Use parameterized queries (Prisma handles this)
- OWASP top 10 awareness: XSS, injection, broken auth, SSRF

Auth matrix (define per project):
- List every route and its required auth level
- Protected routes must check session/token
- Public routes must be explicitly marked as intentionally public
- API routes that modify data require auth — no exceptions

Tenant isolation (if multi-tenant):
- Every query on tenant-scoped models must include tenant context
- No hardcoded tenant IDs, financial thresholds, or tenant-specific logic
- Tenant context resolved at middleware/boundary, passed through
