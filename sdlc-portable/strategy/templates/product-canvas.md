# [Initiative Name] — Product Canvas

## How to use this

Start at Stage 1. Don't touch Stage 2 until Stage 1 is sharp. Don't touch Stage 3 until you're ready to write a spec. Most ideas die at Stage 1 — that's the point.

---

## Stage 1: Thesis (5 minutes)

### Value Proposition (one sentence)

For [customers who ___], [initiative name] [does ___], yielding [___ benefits].

### Audience Scope

Tag one. This determines the conviction bar and investment level.

| Scope | Definition | Example | Conviction test |
|-------|-----------|---------|-----------------|
| **Operator** | Just me / my family | POA-ops, TwoDo, PruneGuice | Would I use this *this week*? |
| **Domain** | Me + others in the same game | OpenClaw, Deal Pipeline, ETA tooling | Can I describe the problem without referencing my situation and it still makes sense? |
| **Product** | Public users, potential business | TwoDo (if graduated), deal-sourcing SaaS | Would a stranger pay for this or choose it over alternatives? |

Scope: ___

**Note:** Things can graduate. TwoDo starts as Operator, becomes Product when the
value prop stands on its own. Tag what it is *now*, not what you hope it becomes.

### The Problem (one paragraph)

What pain exists? Who has it? How do they cope today? What does it cost them?

### The Bet (one paragraph)

Why do we believe this solution works? What's the insight others are missing?

### Conviction check

- **Operator scope:** Does this pass the "would I use it this week" test? → proceed to Stage 2 or kill it.
- **Domain scope:** Can you state the problem generically? Has anyone else described this pain in a forum, podcast, or conversation? → proceed or park it.
- **Product scope:** Write the value prop sentence above to a stranger. Does it land without explanation? → proceed or downgrade to Domain/Operator.

---

## Stage 2: Shape (30 minutes — only if Stage 1 passes conviction check)

### One-Paragraph PR/FAQ

Write one paragraph as if announcing this to the world today. If it doesn't excite you, stop here.

*Operator scope: this can be informal — a sentence to yourself about what you're building and why.*
*Domain/Product scope: write it like a stranger will read it.*

### Users / Personas
Who specifically benefits? (Name real types, not abstractions.)

### Access Scope
Who needs to reach this, and from where?
- [ ] Operator only (Tailscale mesh)
- [ ] Trusted circle (family, partners — Tailscale or authenticated public)
- [ ] Public (anyone on the internet)

### Key Outcomes
What changes in the world if this works?
- Outcome 1 (measurable)
- Outcome 2 (measurable)

---

## Stage 3: Commit (scales with audience scope)

**Operator scope:** Skip this stage. Go straight to a spec or just build it.

**Domain scope:** Answer Risks & Assumptions. Write a spec. Build it.

**Product scope:** Full treatment — risks, constraints, full PR/FAQ, spec with
deployment questionnaire. This is where you decide on domain, auth, public access,
and everything in the [spec template](spec-template.md).

### Risks & Assumptions
What must be true for this to work? What could kill it?

### Constraints
Budget, timeline, technical, regulatory.

### Full PR/FAQ
Expand the one-paragraph version into the [full PR/FAQ template](pr-faq.md)
if this initiative spans multiple specs or involves external users.
