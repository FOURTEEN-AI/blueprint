# 0019. Cross-instance fan-out via PostgreSQL LISTEN/NOTIFY

- Status: Accepted
- Date: 2026-10-14

## Context

When several app machines run, a client connected to machine A has to learn about changes made through machine B. The options were a single instance only, Redis pub/sub, or PostgreSQL LISTEN/NOTIFY.

## Decision

Writes publish a `NOTIFY` on a PostgreSQL channel after commit. Every instance holds **one dedicated, long-lived JDBC connection** (outside the Hikari pool) that `LISTEN`s and forwards events to its local WebSocket sessions. This plumbing lives in its own infrastructure module, separate from any feature.

## Consequences

- No extra infrastructure beyond PostgreSQL.
- On Neon (ADR 0025), the listener has to use the **direct** endpoint, not the pooler. The open connection keeps Neon compute active while the app runs.
- NOTIFY payloads are limited in size, which suits small change notifications.
- The listener needs reconnect logic of its own.
