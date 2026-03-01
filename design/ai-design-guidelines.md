# AI Design Guidelines

Rules for building AI-powered features across sunj-labs. Informed by NNG research and Anthropic's product principles.

## 1. AI as assistant, not autopilot

Tools augment human judgment. PruneGuice suggests deletions — you confirm. OpenClaw surfaces deals — you evaluate. The human is always the strategist. The AI handles throughput.

## 2. Design the seams, not just the surfaces

AI shifts design work from tactical to strategic. Spend more time on decision architecture (what information does the user need to make a good call?) and less on pixel perfection.

## 3. Conservative automation, progressive disclosure

Start every AI-powered feature in "suggest" mode. Graduate to "auto-execute" only after trust is established through observed accuracy. This is PruneGuice's safety philosophy, generalized.

**Automation ladder:**
1. **Manual** — AI does nothing, user does everything
2. **Suggest** — AI proposes, user confirms each action
3. **Batch suggest** — AI proposes batch, user reviews and approves
4. **Auto with veto** — AI acts, user can undo within window
5. **Full auto** — AI acts autonomously (only for proven-safe operations)

Most features live at levels 2-3. Level 5 requires months of observed accuracy data.

## 4. Trace everything

AI systems need observability. Langfuse isn't optional — it's how you maintain taste and quality as automation scales. Every LLM call gets a trace with: model, tokens, cost, latency, input/output summary.

## 5. The generalist advantage

AI makes generalists more valuable than specialists. The design system enables fast movement across contexts without specialist tooling. One person, many tools, shared language.
