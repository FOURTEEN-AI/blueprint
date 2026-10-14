# 0036. Observability: Actuator, JSON logs, Prometheus metrics and OpenTelemetry

- Status: Accepted
- Date: 2026-10-14

## Context

Fly needs health checks, and autonomous releases need signals that show whether production is healthy.

## Decision

- **Spring Boot Actuator** liveness and readiness endpoints, used by Fly health checks.
- **Structured JSON logging**.
- A **Prometheus** metrics endpoint, which Fly can scrape.
- **OpenTelemetry** traces exported to a configurable OTLP endpoint (disabled when none is configured).

## Consequences

- Production can be observed without extra services. Tracing is opt-in.
- Smoke tests and the auto-rollback (ADR 0029) can rely on the health endpoints.
