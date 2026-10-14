# 0022. Host on Fly.io, region fra

- Status: Accepted
- Date: 2026-10-14

## Context

Full continuous delivery (CD) in a public template needs a concrete, affordable target. The options were a pluggable deploy step, Kubernetes, a VM over SSH, or a platform-as-a-service.

## Decision

Applications deploy to **Fly.io** from the GHCR image built by Jib (ADR 0030), configured by a `fly.toml` in the repo. The default region is **`fra` (Frankfurt)**. Users can change it in `fly.toml`. Prod and previews each run in a single region.

## Consequences

- Deploying is a single `flyctl deploy` step in CI with a `FLY_API_TOKEN` secret.
- Spring Boot needs at least 512 MB machines.
- Fly has no real free tier for new accounts. The README states the expected costs.
- Running in one region keeps database latency and LISTEN/NOTIFY simple.
