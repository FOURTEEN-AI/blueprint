# 0089. CODEOWNERS covers all guardrail configuration; admin bypass for the maintainer

- Status: Accepted
- Date: 2026-10-15
- Extends: [0059](0059-branch-protection-and-codeowners.md)

## Context

ADR 0059 assigns a human code owner to `.github/`, `.claude/` and CODEOWNERS. An agent could still weaken the safety net through other files: disable Error Prone, JaCoCo or Spotless in `build.gradle`, delete the ArchUnit tests, change the release command in `fly.toml`, or relax the rules in AGENTS.md.

GitHub also doesn't let anyone approve their own PR. A solo maintainer's own PRs that touch code-owned files, for example from `/sync-blueprint` (ADR 0048), would be stuck.

## Decision

- **CODEOWNERS also covers**:
  - `build.gradle`, `settings.gradle`, `fly.toml`
  - `AGENTS.md`, `CLAUDE.md`, `docs/adr/`
  - the architecture-test package (ArchUnit and Spring Modulith verification) and the traceability check (ADR 0063)
  - lint, format, TypeScript and test-runner configuration (ESLint, Prettier, `tsconfig`, Vitest, Playwright)
- **Dependency versions stay unowned**: they live in `gradle/libs.versions.toml` and `package.json`, so adding or updating a library needs no review.
- Branch rules are a **repository ruleset**. The repository admin is on its **bypass list, for pull requests only**, so the maintainer can deliberately merge their own guardrail PRs. The project App (ADR 0084) has no bypass.

## Consequences

- Turning off a quality gate or an architecture rule always involves a human.
- Changes to the build script itself (new plugins, task wiring) wait for a review.
- Bypass merges are logged by GitHub.
- **Rejected:**
  - Owning everything except application sources, because reviews would be requested for dependencies, specs and migrations.
  - Having the App open human-initiated PRs so the human can approve them, because ad-hoc human branches would still need a workaround.
