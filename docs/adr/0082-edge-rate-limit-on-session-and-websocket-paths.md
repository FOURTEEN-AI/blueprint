# 0082. Edge rate limit on session and WebSocket paths, per-session write limit in the app

- Status: Accepted
- Date: 2026-10-15
- Extends: [0052](0052-cloudflare-in-front-of-production.md) (replaces "matches all write requests"), [0054](0054-app-level-abuse-limits.md)

## Context

ADR 0052 has the free plan's single rate-limiting rule match all write requests, the session endpoint and WebSocket upgrades. Cloudflare's documentation lists only **path** and **Verified Bot** as fields for rate-limiting expressions on the free plan. HTTP method and request headers are available only on higher plans. REST writes share their paths with reads (`GET` and `POST /api/notes`), so the rule can't single out writes.

## Decision

- The edge rule matches the **session endpoint** and the **WebSocket path** only.
- Every write already requires a session cookie (ADR 0053), so limiting session creation limits writers at the edge.
- The app enforces a **per-session write rate limit** (requests per time window per session cookie), in memory per instance, like the other limits of ADR 0054.

## Consequences

- The edge rule works on the free plan and doesn't throttle normal browsing.
- A single verified session can write until the app limit stops it. With several machines the limit is approximate, which ADR 0054 already accepts.
- **Rejected:**
  - Rate-limiting all of `/api/*`, because the limit would have to be generous enough for reads and would barely slow write abuse.
  - A separate path prefix for writes, because it would dictate the REST design of every generated project.
  - No edge limit, because abuse would reach Fly and wake machines.
