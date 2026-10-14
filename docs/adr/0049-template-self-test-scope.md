# 0049. Blueprint's CI tests only the template app

- Status: Accepted
- Date: 2026-10-14

## Context

The init script, the sample removal and `/sync-blueprint` can break silently. One option was to have CI run a non-interactive bootstrap and build the resulting project.

## Decision

Blueprint's CI runs the **normal pipeline on the template app only**. `/bootstrap` and `/sync-blueprint` are tested **by hand**.

## Consequences

- Blueprint's CI stays simple.
- Regressions in bootstrap or sync are found by hand or by users. This can be revisited with a new ADR.
