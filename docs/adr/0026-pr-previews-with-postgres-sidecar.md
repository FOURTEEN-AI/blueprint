# 0026. PR previews with a Postgres sidecar container

- Status: Superseded by [0027](0027-pr-preview-environments.md)
- Date: 2026-10-14

## Context

Each pull request gets its own preview app, which needs an isolated database. The options were a shared preview cluster with one database per PR, a cluster per PR, reusing the prod cluster, or a throwaway Postgres container inside the preview machine.

## Decision

Run a **throwaway PostgreSQL sidecar** in each preview app's Fly Machine, using Fly's multi-container Machines.

## Consequences

Superseded once Neon became the production database (ADR 0025). Neon schema-only branches give previews an isolated database without the rough edges community users have reported with multi-container Machines (sidecar behavior during image replacement, volume declarations).
