# 0087. Production origin TLS: Fly certificate via DNS-01, Cloudflare Full (strict)

- Status: Accepted
- Date: 2026-10-15
- Extends: [0052](0052-cloudflare-in-front-of-production.md)

## Context

ADR 0052 has `/bootstrap` set up "the Fly certificate" for the production domain. Fly's usual validation (TLS-ALPN or HTTP) doesn't work while Cloudflare proxies the hostname, as ADR 0055 already notes. Fly also offers validation through DNS: an `_acme-challenge` CNAME pointing to Fly.

## Decision

- `/bootstrap` runs `fly certs add` for the production hostname and creates the **`_acme-challenge` CNAME** that Fly asks for, **not proxied**. Fly issues and renews the certificate through DNS validation.
- Cloudflare's SSL/TLS mode is **Full (strict)**, so Cloudflare verifies the Fly certificate.

## Consequences

- The connection is verified end to end, and renewal doesn't depend on the proxy.
- One more DNS record to create and keep.
- **Rejected:** Full (non-strict), because Cloudflare wouldn't verify the origin, and Fly needs the hostname registered anyway.
