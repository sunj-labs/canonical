# Diagnosis Standard

When a failure is observed and the cause is not immediately obvious, run
diagnosis before writing any fix.

**Trigger:** "I don't know the root cause before I start fixing."

**When to skip:** Cause is immediately obvious and reproducible — typo,
missing env var, trivial off-by-one. If in doubt, run it. Step 1 takes
two minutes.

---

## Step 1 — Is/Is Not (bound the problem)

Fill in the table before hypothesizing. This prevents fixing the wrong layer.

| IS (failing) | IS NOT (working) |
|---|---|
| The specific thing that fails | The adjacent things that don't |

The table forces you to ask: what is working that is similar to what is
failing? The answer constrains the hypothesis space before you write a line
of code.

---

## Step 2 — Five Whys (trace the chain)

Ask why five times. Stop when you reach something you can change that
prevents the entire class of failure — not just this instance.

The root cause is usually not the symptom. A timeout is a symptom. The
absence of an observability metric that would have caught it earlier is
a root cause.

---

## Step 3 — Hypothesis + Test

Write the hypothesis as one sentence before touching code. Then run the
minimum test that would falsify it. Do not open a PR until the hypothesis
holds.

**Format** (ticket comment before the fix PR opens):

```
Diagnosis:
  IS: [what fails]
  IS NOT: [what works]
  Root cause (5 Whys): [chain ending at the real cause]
  Hypothesis: [one sentence — if X then fixing Y will resolve Z]
  Test: [minimum falsifiable check]
  Result: [pass → proceed / fail → return to step 1]
```

---

## Output

- Diagnosis comment on the ticket before the fix PR
- If Five Whys reveals an architectural gap (missing observability, wrong
  abstraction layer, missing test coverage), open a backlog item before
  closing the bug — the bug is a symptom, the gap is the work
