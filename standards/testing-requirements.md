# Testing Requirements

## Philosophy

Test the things that would cost you money or time if they broke. You're a solo operator — every test must earn its place. No coverage theater.

## Test Pyramid (Solo Operator Variant)

```
         ╱ ╲
        ╱ E2E ╲        ← Rare. Manual smoke tests or critical path only.
       ╱───────╲
      ╱  Integ  ╲      ← Key integration points: API calls, DB, Docker.
     ╱───────────╲
    ╱    Unit     ╲     ← Bulk of tests. Fast, isolated, run on every push.
   ╱───────────────╲
```

## What Gets Tested

### Always Test (non-negotiable)

| What | Why | Example |
|------|-----|---------|
| **Safety rules** | Wrong answer = deleted data, wasted money | PruneGuice skip-lists, OpenClaw confirmation gates |
| **Data transformations** | Garbage in/out breaks downstream | Deal parsing, email classification, financial calculations |
| **Business logic** | Core value of the tool | Deal scoring, SBA 7a qualification, batch action selection |
| **API contracts** | Breaking change = broken system | Tool registry interfaces, agent-to-tool calls |

### Test When Practical

| What | Why | Example |
|------|-----|---------|
| **CLI argument parsing** | Bad UX on wrong input | `openclaw evaluate --deal` with missing/malformed args |
| **Error handling paths** | Graceful degradation matters | API timeout, rate limit, malformed response |
| **Configuration loading** | Wrong config = silent failures | `.env` parsing, Docker env injection |

### Don't Test

| What | Why |
|------|-----|
| Third-party library internals | That's their job |
| Trivial getters/setters | No logic, no risk |
| LLM output content | Non-deterministic; use Langfuse evals instead |
| UI layout | Visual regression is overkill at this scale |

## Test Structure

### Directory Layout

```
repo/
├── src/
│   └── openclaw/
│       ├── agents/
│       ├── tools/
│       └── rules/
├── tests/
│   ├── unit/              ← Mirror src/ structure
│   │   ├── test_agents.py
│   │   ├── test_tools.py
│   │   └── test_rules.py
│   ├── integration/       ← Tests that hit real services (Docker, APIs)
│   │   └── test_tool_registry.py
│   └── conftest.py        ← Shared fixtures
└── pyproject.toml
```

### Naming Convention

```python
# File: test_{module}.py
# Function: test_{what}_{scenario}_{expected}

def test_skip_rule_starred_email_returns_true():
    ...

def test_deal_score_missing_revenue_returns_zero():
    ...

def test_tool_registry_duplicate_name_raises():
    ...
```

Pattern: `test_<object>_<condition>_<outcome>`. Readable without docstrings.

## Framework and Tooling

| Tool | Purpose | Config |
|------|---------|--------|
| **pytest** | Test runner | `pyproject.toml` `[tool.pytest.ini_options]` |
| **pytest-cov** | Coverage reporting | `--cov=src --cov-report=term-missing` |
| **pytest-mock** | Mocking | For isolating API calls, file I/O |
| **pytest-asyncio** | Async test support | For async agent/tool code |

### pyproject.toml Config

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = "test_*.py"
python_functions = "test_*"
addopts = "-v --tb=short --strict-markers"
markers = [
    "unit: fast, isolated tests",
    "integration: tests that require external services",
    "slow: tests that take > 5s",
]

[tool.coverage.run]
source = ["src"]
omit = ["tests/*", "**/__pycache__/*"]

[tool.coverage.report]
fail_under = 0
show_missing = true
exclude_lines = [
    "pragma: no cover",
    "if __name__ == .__main__.",
    "raise NotImplementedError",
]
```

## Coverage Policy

**No hard coverage floor.** Coverage percentage is a vanity metric. Instead:

- Safety rules: 100% branch coverage. No exceptions.
- Business logic: ≥80% line coverage. Test the branches that matter.
- Glue code / CLI / config: test if it's broken you before, skip if it hasn't.

The CI pipeline reports coverage but does not fail on percentage. It fails on test failures.

## CI Integration

Tests run as part of the reusable `python-ci.yml` workflow:

```yaml
# In the org-level python-ci.yml
- name: Run tests
  run: |
    if [ -d "tests" ]; then
      pytest tests/ -v --tb=short -m "not slow"
      pytest tests/ -v --tb=short --cov=src --cov-report=term-missing -m "unit" || true
    fi
```

Key decisions:
- `pytest -m "not slow"` in CI. Slow tests run locally or in nightly jobs.
- `pytest -m "unit"` for coverage reporting. Integration tests excluded from coverage metrics since they depend on external state.
- Coverage report prints to CI log (no external service needed).

## Fixture Patterns

### Shared Fixtures (conftest.py)

```python
import pytest

@pytest.fixture
def sample_deal():
    """A valid Deal object for testing."""
    return {
        "name": "Acme Testing Labs",
        "revenue": 1_200_000,
        "profit": 380_000,
        "asking_price": 1_500_000,
        "source": "bizbuysell",
        "confidence": 0.82,
    }

@pytest.fixture
def sample_rule():
    """A PruneGuice safety rule."""
    return {
        "name": "skip-starred",
        "type": "skip",
        "condition": "is_starred",
        "action": "preserve",
    }
```

### Mocking External APIs

```python
@pytest.fixture
def mock_claude_api(mocker):
    """Mock Anthropic Claude API response."""
    return mocker.patch(
        "openclaw.agents.base.anthropic_client.messages.create",
        return_value=MockResponse(content="Mocked analysis"),
    )

@pytest.fixture
def mock_brave_search(mocker):
    """Mock Brave Search API."""
    return mocker.patch(
        "openclaw.tools.search.brave_search",
        return_value={"results": []},
    )
```

Don't test what Claude says. Test that you called it correctly, handled the response shape, and enforced your rules on the output.

## Writing Tests for Each Repo

### OpenClaw

Focus: agent routing logic, tool registry, rule enforcement, cost tracking.

```python
# test_rules.py
def test_cost_circuit_breaker_triggers_at_limit(mock_claude_api):
    """Circuit breaker stops API calls when spend exceeds daily limit."""
    tracker = CostTracker(daily_limit_usd=5.00)
    tracker.record(cost_usd=4.90)
    with pytest.raises(CircuitBreakerTripped):
        tracker.check_budget()

# test_tool_registry.py
def test_register_tool_duplicate_name_raises():
    registry = ToolRegistry()
    registry.register("search", search_tool)
    with pytest.raises(DuplicateToolError):
        registry.register("search", another_tool)
```

### PruneGuice

Focus: safety rules, email classification, batch action logic.

```python
# test_safety_rules.py
def test_starred_email_never_deleted():
    email = make_email(starred=True, age_days=365)
    assert safety_check(email, action="delete") == SKIP

def test_recent_email_never_deleted():
    email = make_email(starred=False, age_days=2)
    assert safety_check(email, action="delete") == SKIP

def test_batch_action_respects_dry_run():
    emails = [make_email() for _ in range(10)]
    result = batch_delete(emails, dry_run=True)
    assert result.deleted == 0
    assert result.would_delete == 10
```

### Deal Pipeline

Focus: data parsing, scoring, deduplication, source normalization.

```python
# test_parsing.py
def test_parse_bizbuysell_listing_extracts_revenue():
    raw = load_fixture("bizbuysell_listing.html")
    deal = parse_listing(raw, source="bizbuysell")
    assert deal.revenue == 1_200_000

def test_deal_score_weights_profit_margin():
    high_margin = Deal(revenue=1_000_000, profit=400_000)
    low_margin = Deal(revenue=1_000_000, profit=100_000)
    assert score(high_margin) > score(low_margin)
```

## Makefile Convention

Every repo includes:

```makefile
.PHONY: test test-unit test-integration test-coverage lint

test:
	pytest tests/ -v --tb=short -m "not slow"

test-unit:
	pytest tests/unit/ -v --tb=short

test-integration:
	pytest tests/integration/ -v --tb=short

test-coverage:
	pytest tests/unit/ -v --cov=src --cov-report=term-missing --cov-report=html

lint:
	ruff check src/
	bandit -r src/ -ll -q
```

`make test` is the default. Fast, no external deps. Run before every commit.
