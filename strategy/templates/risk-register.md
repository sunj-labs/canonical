# Risk Register Template

Risk is the primary sequencing driver. Every iteration front-loads the work
most likely to invalidate the plan.

## Register

| ID | Description | Type | Likelihood | Impact | Phase ID'd | Mitigation | Status |
|---|---|---|---|---|---|---|---|
| R-001 | ... | Tech/Market/UX/Ops | H/M/L | H/M/L | Inception | ... | open/mitigated/closed |

## Risk types and owners

| Type | Resolved by | Example |
|---|---|---|
| Tech (feasibility) | Architect | "Can we scrape BBS without getting blocked?" |
| Market (viability) | Product Manager | "Will PE firms actually engage with this content?" |
| UX (lovability) | Designer | "Can Mom navigate this on her phone?" |
| Ops (operations) | Deployer | "Will the auto-save work across devices?" |

## Rules

- Any agent can add a risk at any time
- Only the Orchestrator closes risks (status: mitigated or closed)
- At iteration start, Orchestrator surfaces all open risks
- Iteration work is sequenced to close the highest-ranked risk of the type most dangerous at the current phase
- Risks without a mitigation plan are the most dangerous — address them first
