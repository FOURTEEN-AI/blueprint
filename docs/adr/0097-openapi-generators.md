# 0097. OpenAPI generators: openapi-generator for Spring, openapi-typescript for the client

- Status: Accepted
- Date: 2026-10-15
- Extends: [0014](0014-spec-first-openapi.md)

## Context

ADR 0014 generates Spring server interfaces, DTOs and a TypeScript client from `openapi.yaml`, but doesn't name the generators. Spring Boot 4 uses Jackson 3. Generators that emit Jackson 2 specifics (e.g. `JsonNullable` from `jackson-databind-nullable`) may not work with it. The frontend loads and mutates data through React Router loaders and actions (ADR 0016) and needs no generated client classes.

## Decision

- **Server**: openapi-generator's **`spring`** generator through its Gradle plugin, generating interfaces only, with bean validation, used only in the web adapter (ADR 0009).
- **Client**: **`openapi-typescript`** generates the types, and **`openapi-fetch`** (a small typed `fetch` wrapper) calls the API from loaders and actions.

## Consequences

- Constraints in the spec become bean validation on the server (ADR 0054), and the frontend gets fully typed calls with a tiny runtime.
- To verify during implementation: openapi-generator's `spring` generator with Spring Boot 4 and Jackson 3.
- **Rejected:**
  - openapi-generator's `typescript-fetch` for the client, because it produces a heavier, class-based client.
  - Hand-written server types with a contract test, because the server could drift from the spec between test runs.
