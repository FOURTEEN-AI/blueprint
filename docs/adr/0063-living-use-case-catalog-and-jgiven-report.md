# 0063. Living use-case catalog, ID-tagged tests and the JGiven report

- Status: Accepted
- Date: 2026-10-14

## Context

Once implemented, use cases should keep describing the system (bugs refer to them, ADR 0062). Keeping Gherkin in documents *and* tests would duplicate it and drift. We want the JGiven report to be the living, verified specification.

## Decision

- **Catalog**: `docs/use-cases/UC-xxx-<slug>.md` holds what tests can't express: actors, stakeholders and interests, guarantees, security impact, and the main scenario and extensions as numbered prose. Feature PRs create or update entries here.
- **Executable scenarios live only in tests**:
  - JGiven scenarios carry custom JGiven tags such as `@UseCase("UC-012")` and `@Extension("3a")`.
  - Playwright tests carry the same IDs as tags (e.g. `@UC-012`).
  - Gherkin from the backlog item is turned into these tests during implementation and isn't kept anywhere else.
- **Traceability check in CI**: it fails if a use case's main scenario or any extension has no tagged test, or if a tag refers to a use case that doesn't exist.
- **The JGiven report**, grouped by use-case tag, is published to **GitHub Pages** on every release.

## Consequences

- The catalog explains *what and why*, and the JGiven report proves *that it works*. Both are linked by IDs and checked in CI.
- Gherkin lives only in the tests, so there's no second copy to keep in sync.
- Scenario wording in tests has to stay readable, because it becomes public documentation.
