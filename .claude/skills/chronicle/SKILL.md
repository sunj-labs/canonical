---
name: chronicle
description: Write session chronicle entry — narrative record of what happened, decisions made, open threads.
user_invocable: true
disable_model_invocation: false
---

# Chronicle — Write Session Chronicle Entry

Create a timestamped chronicle entry for the current session.

## Steps

1. Read `chronicle/` (or `docs/chronicle/` in app repos) for the latest entry to understand sequence and format
2. Run `git log --oneline` to see what was committed this session
3. Determine today's date and a descriptive slug for the session's work
4. Summarize accomplishments, decisions, and open threads

## Output

Write to `chronicle/{YYYY-MM-DD}-{slug}.md` (or `docs/chronicle/` in app repos):

```markdown
---
session_id: {YYYY-MM-DD}-{HHMM}
project: {active project}
agent: personal
status: completed
tags: [relevant, tags]
---

# Session: {Title}

## Entry State
- State before this session

## Work Done
- Bullet points of accomplishments

## Decisions Made
- Key decisions with rationale

## Open Threads
- What's unfinished or needs follow-up

## Key Files Changed
- List of files created or modified
```

If a chronicle already exists for today, append a letter suffix: `{date}b-{slug}.md`

## Rules

- Open Threads is the most important section — it's what the next session reads first
- Be factual, not promotional. Record what happened, not how great it was.
- Tags should be specific enough to filter by later
