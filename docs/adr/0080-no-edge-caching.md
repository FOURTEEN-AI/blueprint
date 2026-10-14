# 0080. No edge caching at Cloudflare

- Status: Accepted
- Date: 2026-10-14
- Extends: [0052](0052-cloudflare-in-front-of-production.md)

## Context

Cloudflare caches static assets (JS, CSS, images) by default but not HTML. With a single deployable that serves the SPA and the API (ADR 0005), caching rules would have to keep `index.html` fresh while caching hashed assets, possibly with cache purges on deploy.

## Decision

Cloudflare **doesn't cache** anything for production. A cache rule bypasses the cache for all requests, and every request is passed to the origin.

## Consequences

- No stale content after a deploy, and no purge step or cache configuration to maintain.
- Every asset request reaches Fly and can wake a scaled-to-zero machine. That's acceptable for the expected traffic.
- After a deploy, a browser that still has the old `index.html` open may request old, hashed asset files that no longer exist. A reload fixes it. The frontend may catch failed chunk loads and reload automatically.
- **Rejected:**
  - Origin-controlled caching (long-lived hashed assets, `no-cache` HTML), because it's more configuration than the traffic justifies.
  - Cache purges on deploy, for the same reason.
