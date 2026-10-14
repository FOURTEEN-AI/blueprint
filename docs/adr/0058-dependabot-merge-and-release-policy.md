# 0058. Dependabot merge and release policy

- Status: Accepted
- Date: 2026-10-14
- Extends: [0035](0035-dependabot.md), [0032](0032-semantic-release-and-conventional-commits.md)

## Context

By default semantic-release only releases `feat`, `fix` and `perf`. If Dependabot PRs were titled `build(deps)`, security patches would never reach production. Someone also has to merge Dependabot PRs, and major updates can change behavior.

## Decision

- **Commit types**: Dependabot is configured so that **runtime dependency** updates use `fix(deps): …` (a patch release and deploy), while **development and CI dependency** updates use `build(deps): …` or `ci(deps): …` (no release).
- **Patch and minor updates** are merged automatically by GitHub auto-merge once checks are green. They're exempt from the demo requirement of ADR 0057.
- **Major updates** are not merged as they stand. Each becomes a backlog item in `inbox/` (ADR 0061) that the autonomous loop handles, including a demo if behavior changes.
- **GitHub Actions updates** touch `.github/` and therefore wait for a human code-owner review (ADR 0059).

## Consequences

- Security fixes in runtime dependencies reach production without manual work.
- Major upgrades get proper planning instead of a blind merge.
- Actions updates need regular human attention. That's intentional, since they are a supply-chain risk.
