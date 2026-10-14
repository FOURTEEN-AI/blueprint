# 0078. A workflow turns Dependabot major updates into backlog items

- Status: Accepted
- Date: 2026-10-14
- Extends: [0058](0058-dependabot-merge-and-release-policy.md)

## Context

ADR 0058 says major updates become backlog items, but not how. Dependabot opens a PR for every update. Implementing the major update directly in that PR was considered and rejected: it bypasses refinement and the security impact assessment, and it would need a narrower demo exemption (ADR 0072).

## Decision

- A **GitHub Actions workflow** runs on Dependabot PRs. Using `dependabot/fetch-metadata`, it detects **major-version** updates.
- For a major update it:
  1. writes a casual `backlog/inbox/` item (ADR 0062) naming the dependency, the version jump and links to the release notes or changelog,
  2. commits that item in its own `chore` PR, which auto-merges (ADR 0074), and
  3. **closes the Dependabot PR**. Dependabot doesn't reopen it for that version.
- The autonomous loop then handles the item like any other: refine (including security impact), plan, implement, review and ship.

## Consequences

- Major upgrades get the same refinement and review as features.
- The implementing PR is authored by the loop, not Dependabot, so it gets `demo = pending` under ADR 0072 whenever its type is `feat` or `fix`.
- No agent is needed to notice major updates.
