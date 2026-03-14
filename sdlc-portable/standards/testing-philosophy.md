# Testing Philosophy

## Principle

Test the things that would cost you money or time if they broke. Every test must earn its place. No coverage theater.

## Test Pyramid

```
         ╱ ╲
        ╱ E2E ╲        ← Rare. Manual smoke tests or critical path only.
       ╱───────╲
      ╱  Integ  ╲      ← Key integration points: API calls, DB, external services.
     ╱───────────╲
    ╱    Unit     ╲     ← Bulk of tests. Fast, isolated, run on every push.
   ╱───────────────╲
```

## What Gets Tested

### Always test (non-negotiable)

- **Safety rules** — Wrong answer = deleted data, wasted money. 100% branch coverage.
- **Data transformations** — Garbage in/out breaks downstream.
- **Business logic** — The core value of the tool.
- **API contracts** — Breaking change = broken system.

### Test when practical

- CLI / input parsing — bad UX on wrong input
- Error handling paths — graceful degradation matters
- Configuration loading — wrong config = silent failures

### Don't test

- Third-party library internals — that's their job
- Trivial getters/setters — no logic, no risk
- LLM output content — non-deterministic; use observability evals instead
- UI layout — visual regression is overkill at small scale

## Coverage Policy

No hard coverage floor. Coverage percentage is a vanity metric. Instead:

- Safety rules: 100% branch coverage. No exceptions.
- Business logic: ≥80% line coverage. Test the branches that matter.
- Glue code / CLI / config: test if it's broken you before, skip if it hasn't.

## Naming Convention

```
test_{what}_{scenario}_{expected_outcome}
```

Examples:
- `test_skip_rule_starred_email_returns_true`
- `test_deal_score_missing_revenue_returns_zero`
- `test_batch_action_dry_run_deletes_nothing`

Readable without docstrings.

## Fixture Pattern

- Shared fixtures in a common setup file
- Mock external APIs — don't test what the API returns, test that you called it correctly, handled the response shape, and enforced your rules on the output
- Test data as factories, not hardcoded per-test

## CI Integration

- Run fast tests (unit, not slow-tagged) on every push
- Report coverage to CI log, don't fail on percentage
- Fail on test failures only
- Integration tests excluded from coverage metrics (they depend on external state)
