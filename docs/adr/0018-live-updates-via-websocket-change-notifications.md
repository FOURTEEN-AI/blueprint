# 0018. Live updates over a raw WebSocket carrying change notifications

- Status: Accepted
- Date: 2026-10-14

## Context

The sample app shows changes appearing live on several devices (ADR 0021). The transport options were Server-Sent Events, a raw WebSocket and WebSocket with STOMP. The payload could be a bare notification or the full entity.

## Decision

- **Raw WebSocket** (Spring WebSocket, no STOMP).
- Messages are small **change notifications**, e.g. `{ "type": "note.updated", "id": "…" }`, defined in AsyncAPI (ADR 0015). Clients react by calling React Router's `revalidate()`, so all data still flows through the REST API.
- Clients **reconnect automatically** with exponential backoff and jitter, and revalidate after every reconnect. Events missed while disconnected don't matter.
- The UI shows the connection state (live / reconnecting).

## Consequences

- Data stays consistent because REST is the only data path. Each event costs one extra request.
- There's no event replay or event store.
- WebSocket connections keep Fly machines awake while clients are connected (see ADR 0023).
