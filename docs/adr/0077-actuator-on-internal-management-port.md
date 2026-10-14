# 0077. Actuator on an internal management port, and health groups

- Status: Accepted
- Date: 2026-10-14
- Extends: [0036](0036-observability.md), [0052](0052-cloudflare-in-front-of-production.md) (Fly health checks no longer pass through the origin lock)

## Context

ADR 0036 exposes Actuator health and Prometheus endpoints, but nothing kept them off the public domain. They would have been reachable through Cloudflare and `fly.dev`, leaking internals. Fly uses health checks for routing (its proxy skips machines failing their check) and for deploys (a new version goes live only once its checks pass). As far as we know, Fly restarts machines when the process crashes, not when a check fails.

## Decision

- **Actuator listens on a separate management port** (e.g. `8081`). That port is **not** published as a Fly service; only the application port is. Fly's health checks and the `[metrics]` scraping in `fly.toml` reach the management port over Fly's internal network.
- Health groups:
  - **Liveness** checks only the application itself, with no external dependencies.
  - **Readiness** checks the application and the **database**.
  - The **LISTEN/NOTIFY listener** (ADR 0019) reports as its own health component and as a metric, **outside the readiness group**.
- Health checks **don't need the origin-lock header** (ADR 0052), because they never go through Cloudflare.

## Consequences

- Health and metrics are never publicly reachable, with no blocking rules to maintain.
- A new version that can't reach the database never goes live, an extra safety net before the smoke test (ADR 0029).
- A brief listener reconnect can't take the usually single machine (ADR 0023) out of routing. Listener problems show up in Grafana and the logs instead.
- **Rejected:** keeping Actuator on the application port and blocking `/actuator/**` at Cloudflare, because it leaves `fly.dev` exposed and adds a rule to maintain.
- To verify during implementation: that Fly's health checks and metrics scraping don't wake machines that are scaled to zero.
