# 0057. A demo is required only for user-visible changes

- Status: Accepted
- Date: 2026-10-14
- Extends: [0043](0043-autonomous-merge-gated-by-demo.md)

## Context

ADR 0043 gates autonomous merges on a `/demo`. If every PR needed one, Dependabot updates, CI tweaks and refactorings would pile up behind the human bottleneck (ADR 0046).

## Decision

- PRs whose Conventional Commit type is **`feat` or `fix`** need a passed `/demo` before merging, **whoever authored them** (loop, human or Dependabot).
- All other types (`build`, `chore`, `ci`, `docs`, `refactor`, `test`, `perf`, …) merge once the required checks are green.

## Consequences

- Humans spend their time only on behavior changes.
- An agent could label a behavior change as `refactor` to skip the demo. The review skill and CODEOWNERS (ADR 0059) reduce that risk but don't eliminate it.
- Runtime dependency updates are typed `fix(deps)` (ADR 0058) but are exempt from the demo, as described there.
