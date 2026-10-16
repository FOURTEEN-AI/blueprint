# 0124. Gates: one source set, Gradle tasks and the stage files

- Status: Accepted
- Date: 2026-10-16
- Extends: [0042](0042-sdlc-skill-chain.md), [0118](0118-loop-orchestration.md), [0119](0119-loop-routines-and-stages.md), [0122](0122-refine-skill.md), [0102](0102-format-on-edit-and-full-build-stop-hook.md)

## Context

ADR 0118, 0119 and 0122 name many gates and the files they check, but not how they are built, where they run or what the files look like. The test rules of ADR 0105 to 0114 also still need tooling.

## Decision

### Implementation

- Every gate is a **Gradle task** whose logic is **Java** in a separate source set **`gates`** of the single Gradle project ([0006](0006-single-gradle-project-groovy-dsl-pnpm.md)). The gates have their own JUnit tests. The source set is code-owned ([0089](0089-codeowners-scope-and-admin-bypass.md)).
- Hooks, CI and local sessions call the same task.
- **Test gates** (layer disjointness, criticality and PIT target set, contract test per fake, exceptions register, traceability) are checks in the same source set. PIT, ArchUnit, Spring Modulith and JaCoCo remain standard tools underneath. No external gate plugin.
- **Groups:**
  - **Fast** (item, plan, state, traceability, disjointness): part of `check` and of the stage Stop hooks.
  - **Test suite**: part of `check`.
  - **Slow** (PIT, full build with end-to-end tests): in the Stop hooks of implement and ship and in CI, not on every local edit.

### Stage files

All stage files live in `.creation/` on the creation branch. `ship` deletes them, and a CI check fails while the folder exists in a PR ([0118](0118-loop-orchestration.md)).

- **`state.json`** has a fixed schema: `item`, `stage`, `handbacks`, `ciRounds`, `reviewRounds`, `findings` and `failure`. It is written and read only through Gradle tasks. There is no hook that stops direct edits ([0125](0125-guardrails-without-hooks.md)). Instead **every gate compares the file with its version in the previous commit**: counters only rise and only allowed stage transitions pass.
- **`plan.md`** is Markdown with fixed headings: modules and layers, ports, spec changes, migrations, and tests per scenario, the last as a table scenario → test level → test name.
- **`pr.md`** is the draft of the PR text ([0123](0123-pr-kinds-and-dispatch.md)).

### Gates per stage

- **plan gate:**
  - all sections present
  - every scenario of the item has a test row, and no row is unknown
  - named modules exist or are marked new
  - every migration names its expand/contract phase ([0013](0013-expand-contract-migrations.md))
  - every spec change names its file
  - every new port has a fake and a contract test planned, persistence adapters also a round-trip test ([0107](0107-contract-tests-for-fakes.md), [0113](0113-round-trip-tests-for-persistence-adapters.md))
  - planned classes carry `@Criticality` matching the item, and `HIGH` names its target classes ([0114](0114-criticality-annotation-package-and-reassessment.md))
  - every abuse case is covered by a test row or carried over as "Observed, not tested" ([0117](0117-observed-not-tested.md))
  - UI scenarios have a frontend test level ([0112](0112-frontend-tests-count-for-traceability.md))
- **implement:** order is spec, acceptance tests, code. The task `gateRed` runs the new tests, found through the plan table. They must fail with an assertion, not with a compile error, a null pointer or a timeout. Stubs have to compile. Then the full build, traceability and architecture tests must pass ([0102](0102-format-on-edit-and-full-build-stop-hook.md)).
- **review + ship:**
  - Six review agents always run: architecture, security, data and migration, tests and scenario coverage, scope and simplicity, operations and observability. They are **read-only** and return findings in a fixed schema (file, line, severity, reason). The main session fixes blocking findings, at most 2 rounds ([0119](0119-loop-routines-and-stages.md)).
  - The PR title is a valid Conventional Commit and its type fits the diff ([0096](0096-pr-title-is-the-only-conventional-commit.md)).
  - The item is deleted from `ready/` and `.creation/` is gone.
  - The catalog is up to date and the tests are tagged.
  - `pr.md` has all four sections.
  - **Test protection** for `feat` and `fix`: changed or deleted old tests must belong to a use-case ID named in the item's catalog link. For a new use case, no old test is touched. Helper files that can't be assigned may only grow.
- **refine** uses the item gate of [0122](0122-refine-skill.md), also run as a CI check on ideation PRs.

## Consequences

- One place for all checks, written in the project language and tested like production code.
- Fast gates stay cheap enough for stop hooks, slow ones run where waiting is acceptable.
- The Gradle start adds seconds to every gate call.
- State can be edited directly but not unnoticed.
- The gate source set is a new guardrail and needs its own tests.
- **Rejected:**
  - Shell or Python scripts, because their parsers are fragile and hard to test. Node scripts, because they add a second runtime for backend checks.
  - A convention plugin in `buildSrc`, because of its caching pitfalls, and an external gate plugin, because guardrails would depend on a third party.
  - Everything in `check`, because PIT would slow down every local build.
  - YAML for the state file, because the model writes it less reliably than JSON written by a task.
  - Strictly forbidding changes to old tests in `feat`, because changing an existing use case has to adapt its tests.
