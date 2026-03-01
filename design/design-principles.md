# Design Principles — The Seven Rules

These guide every UI, CLI, bot message, and API response across sunj-labs.

## 1. Clarity over cleverness
*(Apple, Intercom)*

Every interaction answers one question: *What should I do next?* If the answer isn't obvious, the design failed.

## 2. Understand intent, not just input
*(Anthropic — Boris Cherny)*

Interpret what the user is trying to accomplish, not the literal request. Clarify ambiguity rather than guess. "Delete old emails" means different things to different people — surface the interpretation before acting.

## 3. Show the work
*(NNG, Anthropic — Constitutional AI)*

Expose reasoning, confidence levels, sources, and what was considered and rejected. Trust is built through transparency, not magic. Especially critical in deal sourcing where a false positive wastes months.

## 4. Be honest about limits
*(Anthropic — Boris Cherny)*

Say "I don't know." Show `confidence: 62%` rather than hallucinate certainty. Confidence without accuracy is dangerous.

## 5. Progressive density
*(Apple HIG, Google Material)*

Start sparse. Add information as requested. A deal summary starts as three lines. Drill down for financials. Drill deeper for source data.

## 6. Consistent objects, flexible surfaces
*(Intercom full-stack)*

A "Deal" looks different in Telegram than in a web dashboard, but it always contains the same core information in the same hierarchy. The object model is fixed. The rendering adapts.

## 7. Respect the operator
*(Anthropic, IDEO)*

Present data and tradeoffs. Don't make decisions for the user. Don't patronize with unnecessary confirmations on safe actions. Demand confirmation on destructive ones. Match the tool to the operator's skill level.
