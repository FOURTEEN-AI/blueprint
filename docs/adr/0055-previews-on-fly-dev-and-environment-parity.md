# 0055. PR previews stay on fly.dev; environments differ only in configuration

- Status: Accepted
- Date: 2026-10-14
- Extends: [0051](0051-preview-databases-as-fresh-database-in-pr-branch.md)

## Context

Putting previews behind Cloudflare (`pr-<n>.preview.<domain>`) would need DNS records, Fly certificates and Cloudflare rules for every PR. Fly's usual certificate validation also fails behind Cloudflare's proxy, and the free plan's rule limits would cap how many previews can exist. Extra guards just for previews (basic auth, an in-app rate limiter) would make previews behave differently from production.

## Decision

- PR previews stay on their plain **`<app>-pr-<n>.fly.dev`** URLs, **not behind Cloudflare**, and get **no extra protection**.
- Previews are protected by:
  - their short lifetime (TTL, destroyed on close)
  - empty data (ADR 0051)
  - the generic app-level limits (ADR 0054)
- **Environment parity**: every environment runs the same image and the same code paths. Environments differ **only in configuration**: Turnstile test keys versus real keys, and the origin lock enabled or not (ADR 0052). Nothing is built, and no code path exists, specifically for previews.

## Consequences

- Preview deploys stay simple, with no per-PR DNS, certificates or Cloudflare rules.
- Anyone who learns a preview URL can write to it while it exists. That's accepted, because previews are short-lived and hold no real data.
- **Rejected:**
  - Private previews reachable only through `fly proxy`, because live updates could no longer be demoed across several devices.
  - Basic auth on previews only, because it would make previews behave differently from production.
