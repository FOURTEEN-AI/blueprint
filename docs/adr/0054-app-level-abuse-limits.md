# 0054. Generic app-level abuse limits

- Status: Accepted
- Date: 2026-10-14

## Context

Edge protection (ADR 0052) only covers production, and the free plan can't limit concurrent WebSocket connections. Generated projects should keep a basic protection layer that works in every environment.

## Decision

The template infrastructure (kept by `/bootstrap`) enforces:

- **Request size limits**: a maximum request body size, plus field constraints (`maxLength`, `maxItems`, patterns) declared in `openapi.yaml` and enforced by bean validation on the generated DTOs.
- **WebSocket limits**:
  - at most N sockets per session cookie (per instance)
  - server push only: any message from the client closes the socket
  - idle timeouts and maximum socket lifetimes, after which clients reconnect (ADR 0018)

## Consequences

- The limits apply the same way locally, in previews and in production.
- Limits per instance are approximate when several machines run. That's acceptable together with the edge rule.
- Spec-first constraints make the limits visible in the API contract.
