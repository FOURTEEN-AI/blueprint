# 0053. Turnstile bot check once per session for writes and WebSockets

- Status: Accepted
- Date: 2026-10-14

## Context

IP-based rate limiting (ADR 0052) slows abuse down but doesn't tell bots from humans. Challenging every single write with a single-use token would be awkward for users and for the generated client code.

## Decision

- The frontend runs a **Cloudflare Turnstile** check **once per session** and sends the token to a session endpoint. The backend verifies it with Cloudflare and issues a **short-lived, HMAC-signed session cookie**. The signing key is an environment variable shared by all instances.
- **All writes and WebSocket connections require a valid session cookie.** Reads don't.
- **Tests**:
  - CI and PR previews use Turnstile's **always-pass test keys**.
  - The production smoke test (ADR 0040) sends a **secret bypass header** (a GitHub secret), which the session endpoint accepts instead of a Turnstile token.

## Consequences

- Visitors are checked on their first visit, since the WebSocket connects on page load. That's usually invisible.
- Bots can't hold many WebSockets open, which would keep machines and Neon awake.
- The session cookie is **not authentication** and identifies no user, so ADR 0020 still holds.
- The bypass secret is a credential. If it leaks, rotating it is a config change.
