# Testing Strategy

## Philosophy

Three test layers, each catching different failure classes at different costs.
All three are required. Skipping a layer doesn't save time — it shifts the
cost to production debugging.

## Test Layers

### Layer 1: Unit Tests

**What they catch**: Logic errors in pure functions — scoring returns wrong
value, parser misses a field, normalizer corrupts data.

**When they run**: Before every commit. CI blocks on failure.

**Cost**: Low — 10-30 minutes to write per function, milliseconds to run.

**Rule**: New pure function = new test. No exceptions. The pre-commit hook
WARNs if a new source file has no matching test file.

| Enforcement Point | Strength | Mechanism |
|-------------------|----------|-----------|
| Pre-commit hook | 🟡 WARN | Check if new `src/lib/*.ts` has matching `src/__tests__/*.test.ts` |
| Pre-commit hook | 🟡 WARN | Test count regression (decreased = WARN) |
| CI pipeline | 🔴 BLOCK | `vitest run` must pass or deploy is rejected |

**What to test**:
- Scoring functions — input/output contracts
- Parsers/normalizers — edge cases, null handling
- Classification logic — keyword matching, thresholds
- Cost calculations — per-model pricing, budget tracking
- Pure utilities — currency formatting, date parsing

**What NOT to unit test**:
- Database queries (integration layer)
- API route handlers (E2E layer)
- UI component rendering (E2E layer)
- Configuration/wiring code

### Layer 2: Integration Tests

**What they catch**: Pipeline wiring failures — scraper runs but deals don't
land in DB, scorer runs but scores aren't attached, dedup finds nothing
because query is wrong.

**When they run**: Before deploy (CI step), or on-demand via skill.

**Cost**: Medium — 1-2 hours to write initially, 30-60 seconds to run.

| Enforcement Point | Strength | Mechanism |
|-------------------|----------|-----------|
| CI pipeline | 🔴 BLOCK | Integration test suite runs against test DB |
| On-demand | Manual | `/test-integration` skill with full procedure |

**Infrastructure**: Local Docker Compose with separate test DB.
No external service mocking — use real DB, real Redis, mock only
external APIs (ScraperAPI, Gmail, Anthropic) at the HTTP level.

```yaml
# docker-compose.test.yml
services:
  test-db:
    image: postgres:16
    environment:
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
      POSTGRES_DB: poa_test
    ports: ["5434:5432"]
  test-redis:
    image: redis:7
    ports: ["6381:6379"]
```

**What to test**:
- Scraper → normalizer → DB: deals land with correct fields
- Scorer → DealScore: all dimensions created atomically
- Email ingestor → classifier → parser: end-to-end email processing
- Dedup → grouping: cross-source matches identified
- Auth flow → session → tenant context: user gets correct role + tenant

### Layer 3: E2E / Smoke Tests

**What they catch**: User-facing failures — page doesn't load, auth
redirect loops, API returns wrong shape, middleware blocks routes.

**When they run**: After every production deploy.

**Cost**: Low for smoke tests (curl-based, 10 seconds), medium for
browser-based (Playwright, 60 seconds).

| Enforcement Point | Strength | Mechanism |
|-------------------|----------|-----------|
| CI post-deploy | 🔴 BLOCK | Curl-based smoke tests (health, API, auth redirect) |
| On-demand | Manual | `/test-e2e` skill with full 8-check procedure |

**Smoke test minimum (in CI)**:
```bash
# 1. App is alive
curl -sf $APP_URL/api/health | jq -e '.status == "healthy"'

# 2. API returns data
curl -sf "$APP_URL/api/deals?limit=1" | jq -e '.deals | length > 0'

# 3. Auth redirect works (unauthenticated → 307)
[ "$(curl -so /dev/null -w '%{http_code}' $APP_URL/)" = "307" ]
```

**Full E2E (on-demand via `/test-e2e`)**:
- Health check
- Auth flow (redirect, sign-in page, OAuth provider config)
- Dashboard loads
- Deals list with pagination
- Deal detail with scores
- Filters work
- API routes return correct shapes
- Worker is running
- Recent jobs in DB

## Test Server Strategy

| Environment | Use Case | When |
|-------------|----------|------|
| **Local Docker Compose** | Unit + integration tests | Development, CI |
| **Production** | Post-deploy smoke tests | After every deploy |
| **Staging** (future) | Browser-based E2E, destructive tests | When Playwright or multi-user testing needed |

Start with local + production. Add staging when the test requirements outgrow
what curl-based smoke tests can cover.

## Change Type → Required Tests

| Change | Unit | Integration | E2E Smoke |
|--------|------|-------------|-----------|
| Pure function (scoring, parsing) | ✅ Required | — | — |
| Agent / worker logic | — | ✅ Required | — |
| API route | — | ✅ Required | ✅ Post-deploy |
| Schema migration | — | ✅ Required | — |
| Middleware / auth | — | — | ✅ Required |
| Scraper / data source | — | ✅ Required | — |
| UI component | — | — | ✅ Post-deploy |
| Config / env var | — | — | ✅ Post-deploy |

## SDLC Trace Log Entry

Every test execution should produce a trace log entry:

```
timestamp | test-layer | trigger | count_pass | count_fail | outcome
```

This feeds into process observability (platform-docs#8).
