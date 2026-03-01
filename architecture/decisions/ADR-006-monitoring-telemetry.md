# ADR-006: Monitoring, Heartbeat, and Telemetry

## Status
ACCEPTED

## Date
2026-03-01

## Context
Running multiple Docker services (OpenClaw, Langfuse, Postgres, and growing) on a single EC2 instance with no visibility into host health, container status, or resource trends. Langfuse covers LLM observability but not infrastructure. Need to know: is it alive, is it healthy, is it burning money.

The constraint principle applies: Prometheus + Grafana is enterprise-grade overkill for one box. We need the lightest thing that gives us heartbeat, metrics history, and alerting.

## Decision

Three layers:

### Layer 1: Heartbeat — Docker HEALTHCHECK + cron + Signal

No new services. Docker's native health checks detect unresponsive containers. A cron script polls `docker ps --filter "health=unhealthy"` every 60 seconds and alerts via Telegram (already running on the box).

Each service in `docker-compose.yml` gets a `healthcheck` directive:

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:PORT/health"]
  interval: 30s
  timeout: 5s
  retries: 3
```

Cost: zero. New infrastructure: none.

### Layer 2: Metrics + Alerting — Beszel

Beszel hub runs as a Docker container on EC2. Agent runs as a single Go binary on the host. Provides:

- CPU, memory, disk, network history per host
- Per-container CPU and memory tracking
- Configurable alerts (disk filling, memory leak, CPU spike)
- Web UI on port 8090, accessible via Tailscale only

Resource footprint: ~30 MiB for hub, ~6 MiB for agent.

Cost: zero (MIT license, self-hosted). New infrastructure: one Docker container.

### Layer 3: API Cost Circuit Breaker — Custom

A lightweight cost tracker reading Langfuse trace data. Sums Anthropic API spend per day/agent. Trips a breaker at configurable threshold ($X/day). Prevents runaway agent loops from draining the API budget.

This is code in OpenClaw, not new infrastructure.

## What We Skip

| Tool | Why Not |
|------|---------|
| Prometheus + Grafana | Overkill. Multiple containers, complex config, high resource use. Revisit if we go multi-node. |
| Uptime Kuma | Designed for HTTP uptime of many endpoints. We have one box behind Tailscale. Beszel covers container health better. |
| Netdata | Heavier than Beszel, overwhelming default dashboards, long-term storage needs extra setup. |
| Datadog / New Relic / cloud SaaS | Vendor, cost, data leaves our infra. Violates constraint principle. |

## Consequences

### Positive
- Near-zero resource footprint
- Heartbeat alerting with no new services
- Beszel gives historical trends for capacity planning
- Cost circuit breaker prevents financial damage from agent bugs
- Everything stays behind Tailscale

### Negative
- Beszel is a younger project (mitigated: MIT license, active development, growing adoption)
- No distributed monitoring (acceptable: single box)
- Telegram alerting requires the Telegram bot to be reachable (mitigated: cron can fall back to writing to a file or email)

### Risks
- EC2 instance itself goes down (mitigated: AWS CloudWatch basic monitoring is free, set a CPU/status check alarm that emails you — this is the one external canary)
