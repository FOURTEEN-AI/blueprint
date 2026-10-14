# 0052. Cloudflare in front of production

- Status: Accepted
- Date: 2026-10-14
- Extends: [0022](0022-fly-io-hosting.md), [0040](0040-playwright-e2e-placement.md), [0047](0047-bootstrap-skill.md)

## Context

The template has no authentication (ADR 0020), so production write endpoints and WebSockets are open to anyone on the internet. Rate limiting inside the app would only count per machine, or would put load on the database (ADR 0019 already keeps one Neon connection busy). Edge protection avoids both problems.

## Decision

- Production is served through **Cloudflare (free plan)** on a **custom domain** whose DNS Cloudflare manages. This is **mandatory** for generated projects. `/bootstrap` asks for a Cloudflare zone and API token and sets up DNS, rules and the Fly certificate.
- **Rate limiting at the edge**: the free plan's single IP-based rate-limiting rule matches all write requests, the session endpoint (ADR 0053) and WebSocket upgrades. Limits are generous, because legitimate users can share an IP (carrier-grade NAT, offices).
- **Origin lock**: a Cloudflare request-header Transform Rule adds a secret header (e.g. `X-Origin-Auth`) to every request sent to Fly. A servlet filter rejects requests without the correct value. Fly HTTP health checks send the header too. The filter is active **only when the secret is configured**, which is in production. It's the same code in every environment (ADR 0055).
- **Client IP**: behind Cloudflare, the real client IP is in `CF-Connecting-IP`. The app trusts that header only on requests that passed the origin lock.

## Consequences

- Abuse traffic is mostly stopped before it reaches Fly, so it can't wake scaled-to-zero machines (ADR 0023) or Neon.
- Every template user needs their own domain (an annual cost) moved to Cloudflare. The README states this as a prerequisite.
- The `<app>.fly.dev` URL of production is effectively unusable, because it's blocked by the origin lock.
- **Rejected:**
  - Cloudflare Tunnel, because `cloudflared` runs inside the machine, so a stopped machine has no tunnel and can't be woken.
  - An allowlist of Cloudflare IPs, because the ranges change and need upkeep.
- Free-plan limits (one rate-limiting rule, a short fixed window) were checked against third-party sources, which disagree slightly. Verify them in the dashboard during implementation.
