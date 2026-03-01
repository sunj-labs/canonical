# Object Model

The shared nouns of the sunj-labs ecosystem. Same word everywhere — code, issues, Telegram, Langfuse, database schemas. No synonyms.

## Core Objects

| Object | Description | Appears In |
|--------|-------------|------------|
| **Deal** | A potential acquisition target | OpenClaw, Deal Pipeline, POA |
| **Agent** | An AI agent with a role and tools | OpenClaw |
| **Tool** | A callable capability (PruneGuice, scraper, etc.) | OpenClaw, individual repos |
| **Task** | A unit of work tracked on the board | GitHub Projects, all repos |
| **Trace** | An observed LLM interaction | Langfuse |
| **Candidate** | An SBA 7a business listing | POA-ops, Deal Pipeline |
| **Rule** | A safety/business constraint | PruneGuice, OpenClaw |

## Relationships

```
Agent --uses--> Tool
Agent --evaluates--> Deal
Agent --produces--> Trace
Deal --qualifies-as--> Candidate (when SBA 7a criteria met)
Tool --governed-by--> Rule
Task --references--> Deal | Agent | Tool
```

## Rules for Object Evolution

When building a new feature, ask: *Can I express this using objects that already exist?*

New objects are expensive. Reuse is cheap. If you need a new object, it gets added here first — not invented ad hoc in a single repo.
