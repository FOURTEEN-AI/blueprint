# 0039. JGiven port-to-port tests against in-memory fakes

- Status: Accepted
- Date: 2026-10-14

## Context

Backend behavior is tested at the application boundary (port to port) in the onion architecture (ADR 0008). Behind the outbound ports there can be in-memory fakes or the real adapters running on Testcontainers.

## Decision

- **JGiven** scenarios drive the application through its **inbound ports**.
- **Outbound ports** (repositories, notifiers, …) are implemented by **in-memory fakes**. There's no Spring context and no database.
- Each real adapter gets its own **Testcontainers integration tests**, e.g. JPA repositories against PostgreSQL and the LISTEN/NOTIFY listener.

## Consequences

- Behavior tests are fast enough to run on every change.
- Fakes have to behave like the real adapters. Shared contract tests can enforce that.
- JGiven produces readable scenario reports that map back to the Gherkin criteria.
