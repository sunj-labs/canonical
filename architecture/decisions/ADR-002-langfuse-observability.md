# ADR-002: Langfuse for LLM Observability

## Status
ACCEPTED

## Date
2026-02-28

## Context
OpenClaw makes LLM calls across three agents (Personal, ETA, POA). Without observability, we can't track cost, latency, quality, or debug agent behavior. Need tracing that covers every Claude API call.

NNG research emphasizes that AI systems need observability to maintain quality as automation scales. Design Principle #3 ("Show the work") requires transparency infrastructure.

## Decision
Self-host Langfuse on EC2 via Docker Compose, alongside the existing OpenClaw stack.

- Langfuse + Postgres containers in `docker-compose.yml`
- Python SDK wraps every `anthropic.messages.create()` call
- Traces capture: model, token count, cost, latency, input/output summary
- Accessible via Tailscale (no public exposure)

## Consequences

### Positive
- Full trace visibility for every LLM interaction
- Cost tracking per agent, per tool, per session
- Self-hosted = no data leaves our infra
- Free (open source, self-hosted)
- Eval framework for later quality measurement

### Negative
- Additional Docker containers consuming EC2 resources
- Postgres backup responsibility
- SDK integration effort per repo

### Risks
- EC2 resource pressure (mitigated: Langfuse is lightweight, Postgres is small at our volume)
- Langfuse project stability (mitigated: active development, MIT license, growing adoption)
