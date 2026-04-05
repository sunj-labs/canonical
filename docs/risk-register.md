# Risk Register

| ID | Description | Type | Likelihood | Impact | Phase ID'd | Mitigation | Status |
|----|-------------|------|-----------|--------|-----------|------------|--------|
| R-001 | Autonomous sessions produce incomplete artifacts — hooks fail, session-end doesn't fire, chronicles/LinkedIn drafts get skipped | Tech | H | H | Construction (2026-04-04) | #45 session-end resilience — tiered obligations, explicit skill, not hook-dependent | open |
| R-002 | Substrate wiring breaks silently in new environments — symlinks, hooks, CLIs not validated until mid-session failure | Ops | M | H | Construction (2026-04-04) | #46 substrate self-test — validate full chain before agents activate | open |
| R-003 | Orchestrator spawns work without aggregate safety checks — parallel builders touch same files, features misclassified as fixes | UX | M | H | Construction (2026-04-04) | #74 aggregate temperance — batch scope check before fan-out | open |
