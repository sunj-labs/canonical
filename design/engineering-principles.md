# Engineering Principles

Applies to all sunj-labs systems — agentic and non-agentic, backend and
frontend. These are the rules that govern how we divide and structure code.

---

## The Core Three

### 1. Separation of Concerns (SoC)

Each module has exactly one reason to change. Mixing concerns — business logic
with persistence, presentation with data fetching, orchestration with business
rules — means unrelated changes break each other and unrelated tests have to
know about each other.

> *A module should be changeable for one reason without touching its
> neighbours.*

The tell: when you find yourself writing "and also" to describe what a module
does, it has two concerns.

---

### 2. Abstraction — implement once, vary at the boundary

Significant logic lives in exactly one place. Callers receive a named
boundary — a function signature, an interface, a type — not a copy of the
implementation. Duplication is the symptom; the cure is an abstraction that
makes the variation explicit.

The DRY principle is the popular formulation, but the deeper point is that
**a boundary makes a contract.** The contract is what callers depend on, not
the implementation behind it. Changing the implementation without changing the
contract is safe. Changing the contract is a breaking change — make it
deliberate.

---

### 3. Interface-driven development

Define the contract before writing the implementation. The interface is the
design artifact. The implementation is the fulfillment.

```
What does the caller need to know?     → that is the interface
What does the implementation need?     → that is hidden behind it
```

This applies at every scale: a function signature, a module export, an API
route, a queue job schema, an agent's input/output type. The pattern is
identical — define the boundary, then build inward.

---

## Earn Your Keep

Every separation has a cost: indirection, files to navigate, interfaces to
maintain. A separation earns its keep when it delivers at least one of:

| Benefit | Test |
|---|---|
| **Testability** | Can you verify this module in isolation without mocking its callers? |
| **Replaceability** | Can you swap the implementation without changing callers? |
| **Parallelizability** | Can two developers work on each side simultaneously? |
| **Blast radius reduction** | Does a change here leave unrelated modules untouched? |

If none of these apply, the separation adds cost without benefit. Don't add it.

**The three questions — run before adding any boundary:**

1. What changes independently here? *(SoC trigger — if nothing, don't separate)*
2. What would a test need to know about the caller or infrastructure?
   *(each answer is a dependency that should be injected, not assumed)*
3. How many files break if the implementation changes?
   *(if too many, a facade is missing)*

---

## Where the Principles Apply

These are not agentic-specific. The same rules apply at every layer:

| Layer | SoC boundary | Interface |
|---|---|---|
| UI components | Presentational vs. data-fetching | Props contract |
| API routes | HTTP handling vs. business logic | Request/response schema |
| Business logic | Domain rules vs. persistence | Service function signature |
| Data access | Query construction vs. connection management | Repository interface |
| Workers / agents | Business logic vs. orchestration | Typed input/output |
| External integrations | Client call vs. retry/circuit logic | Wrapper function with owned error types |

The agentic flywheel pattern (in `strategy/sdlc-process.md`) is one
application of this to multi-agent systems. It is not a special case — it
follows the same rules as everything else.

---

## Signs a Boundary is Missing

- A test that needs to set up 4+ things unrelated to what it's testing
- A change to a scraper that requires touching a digest file
- A function that can't be called without starting a database or queue
- Two modules importing each other (circular dependency = missing abstraction)
- A module named `utils.ts`, `helpers.ts`, or `misc.ts`

## Signs a Boundary is Unnecessary

- An interface with exactly one implementation and no plan to add another
- An abstraction layer that just delegates every call without adding anything
- A module that exists to be "organized" but never tested or replaced in isolation
- A facade over something that is already a stable external contract (e.g.,
  wrapping Prisma's `findMany` when Prisma itself is the interface)

---

*References: Fowler EAA Catalog, GoF Design Patterns, Dijkstra's Separation of
Concerns (1974), DRY (Hunt & Thomas — The Pragmatic Programmer)*
