---
globs: ["**/*.ts", "**/*.tsx", "**/*.test.*", "**/*.spec.*"]
description: Three-layer test strategy — loads when touching source or test files
---

Three layers, all required. Skipping shifts cost to production debugging.

Layer 1 — Unit (vitest):
  Pure function logic. New pure function = new test, no exceptions.
  Pre-commit WARNs if new source file has no matching test.
  CI BLOCKs on failure.

Layer 2 — Integration:
  Pipeline wiring. Real DB + real Redis, mock only external APIs at HTTP level.
  CI BLOCKs on failure.

Layer 3 — E2E/Smoke:
  Post-deploy. Curl-based minimum (health, API, auth redirect).
  Playwright for critical user paths when needed.

Coverage policy:
  100% branch for safety rules. ≥80% line for business logic.
  Skip glue code, trivial getters, third-party internals, LLM output content.

Naming: `test_{what}_{scenario}_{expected_outcome}`
Fixtures: factories not hardcoded data.

Change matrix:
  Pure function → unit. Agent/worker → integration. API route → integration + smoke.
  Schema migration → integration. Middleware/auth → E2E. UI component → smoke.
