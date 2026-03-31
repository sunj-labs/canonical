---
name: principal-engineer
description: Review code through the lens of world-class engineering patterns — GoF, Fowler, SOLID, DDD. Flag violations, suggest improvements.
user_invocable: true
disable_model_invocation: false
---

# Principal Engineer Review

Apply time-tested software engineering patterns as a review lens.

## Patterns to Apply

### SOLID Principles
- **SRP** — Does this module do one thing? Would you change it for more than one reason?
- **OCP** — Can you extend behavior without modifying existing code?
- **LSP** — Can subtypes replace their parents without breaking callers?
- **ISP** — Are interfaces lean? Do implementers stub methods they don't use?
- **DIP** — Do high-level modules depend on abstractions, not concretions?

### Gang of Four (GoF) — Apply When Relevant
- **Strategy** — scoring dimensions, data sources (each implements same interface)
- **Observer** — job completion events, webhook callbacks
- **Factory** — creating agents/workers by type
- **Template Method** — base class with customizable steps
- **Adapter** — wrapping external APIs with consistent interface
- **Circuit Breaker** — external service resilience

### Fowler Patterns
- **Repository** — data access abstraction (are queries leaking business logic?)
- **Service Layer** — is business logic in the right layer?
- **Domain Events** — should actions trigger other actions?
- **Value Objects** — are primitives used where domain types would be clearer?
- **Specification** — complex query filters should be composable

### Domain-Driven Design
- **Bounded Contexts** — are domains properly separated?
- **Aggregates** — are entity boundaries correct?
- **Ubiquitous Language** — do code terms match business terms?

### Pragmatic Rules
- **YAGNI** — Don't build what you don't need. DO build the boundary so it's easy to add later.
- **Tell, Don't Ask** — Objects should do things, not be interrogated for state
- **Law of Demeter** — Don't reach through objects
- **Composition over Inheritance** — Prefer composing behaviors
- **Fail Fast** — Validate at boundaries, throw early

## Review Procedure

1. Read the code being reviewed
2. For each file/module, check against the patterns above
3. Flag violations with: pattern violated, current code, suggested improvement, severity
4. Acknowledge good patterns already in place
5. Produce summary: N critical, N improvement, N nitpick

## When NOT to Apply

- Don't over-engineer simple CRUD
- Don't add abstractions for one-time operations
- Don't refactor working code just because it could be "more OOP"
- Three similar lines is better than a premature abstraction
- Apply patterns when they solve a real problem, not for aesthetics
