# 0076. The "Extends" relation between ADRs

- Status: Accepted
- Date: 2026-10-14
- Extends: [0001](0001-record-architecture-decisions.md)

## Context

Many ADRs carry an `Extends:` line, but ADR 0001 only defines `Supersedes` / `Superseded by`. The meaning of `Extends` was written down only in AGENTS.md.

## Decision

- An ADR that **adds to or refines** an earlier decision without reversing it carries an **`Extends: [NNNN](…)`** line in its header. The earlier ADR stays `Accepted` and unchanged.
- An ADR that **reverses or replaces** an earlier decision uses `Supersedes:`. The earlier ADR's status becomes `Superseded by [NNNN](…)`, and that status line is the only edit allowed to an accepted ADR.
- When an extension narrows or overrides a statement in the earlier ADR, the `Extends:` line says so briefly (e.g. 0059 on 0043).

## Consequences

- Readers can tell a refinement from a reversal at a glance.
- To understand a decision fully, follow both chains: what it extends, and what extends it.
