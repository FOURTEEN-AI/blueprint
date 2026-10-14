# 0008. Spring Modulith feature modules with onion layers inside

- Status: Accepted
- Date: 2026-10-14

## Context

Agent-written code drifts toward tangled dependencies unless the structure is explicit and checked. Options included a classic layered structure, plain package-by-feature, hexagonal architecture and Spring Modulith.

## Decision

- **At the top level**: package-by-feature, with each feature a **Spring Modulith application module** (e.g. `notes`, `live`). Module boundaries are verified in tests.
- **Inside each module**: **onion architecture**. The domain is at the center, then the application layer (use cases and ports), then infrastructure and web adapters on the outside. Dependencies only point inward.

## Consequences

- Clear places for every kind of code, which agents can follow mechanically.
- Spring Modulith's module documentation and verification come for free.
- There's more structure (and more files) than a CRUD demo strictly needs. We accept that, since the template exists to show the pattern.
