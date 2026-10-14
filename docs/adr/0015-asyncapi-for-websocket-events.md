# 0015. AsyncAPI for WebSocket events

- Status: Accepted
- Date: 2026-10-14

## Context

Live updates go over a WebSocket (ADR 0018). Their event schema also needs a contract, kept consistent with the spec-first approach for REST (ADR 0014).

## Decision

WebSocket events are defined in an **`asyncapi.yaml`** next to `openapi.yaml`. TypeScript types (and Java types, where useful) are generated from it.

## Consequences

- REST and events are both documented and generated from specs.
- One more spec and one more codegen toolchain to maintain. AsyncAPI tooling is less mature than OpenAPI's.
