# 0064. Preview databases: one shared Neon branch with a database per PR

- Status: Accepted
- Date: 2026-10-14
- Supersedes: [0051](0051-preview-databases-as-fresh-database-in-pr-branch.md)

## Context

ADR 0051 created a schema-only Neon branch per PR. On Neon, schema-only branches are **root branches**, and the free plan allows only **3 root branches per project, including the main branch**. So at most two previews could exist at once, while every PR from the main repository (including Dependabot) gets a preview. In ADR 0051 the branch only served as a container anyway, because the preview uses a fresh database inside it.

## Decision

- There is **one persistent `previews` branch**, created by CI as a schema-only branch of production **if it's missing**, so it never contains production data.
- Each PR gets its **own empty database** in that branch (e.g. `pr_<n>`). The release command runs all Flyway migrations from `V1` (ADR 0012). The database is **dropped** when the preview is destroyed (PR closed or merged, TTL, nightly cleanup).

The rest of ADRs 0027/0051/0055 still applies.

## Consequences

- Previews use exactly one branch, whatever the number of open PRs.
- PR databases share the `previews` branch's compute, which is fine for short-lived, low-traffic previews.
- The nightly cleanup drops orphaned PR databases as well as Fly apps.
- No one-time setup is needed, because CI creates the branch itself.
