# 0006. Single Gradle project with the Groovy DSL, and pnpm

- Status: Accepted
- Date: 2026-10-14

## Context

The build could be a Gradle multi-project (`:backend`, `:frontend`, `:api`), a multi-project with convention plugins in `build-logic/`, or a single project. Gradle build scripts can be written in Kotlin or Groovy. The frontend needs a Node package manager.

## Decision

- A **single Gradle project**: backend sources in `src/main/java`, the React app in `frontend/`, built by Gradle tasks that call pnpm.
- Build scripts use the **Groovy DSL** (`build.gradle`).
- **pnpm** is the Node package manager, enabled through corepack. The Node version is pinned in the repo.

## Consequences

- The layout is simple and easy for newcomers and agents to navigate.
- Module boundaries are enforced in code (ADR 0008/0009), not by Gradle subprojects.
- The Groovy DSL gives up some IDE type-safety compared to the Kotlin DSL.
- pnpm is faster and resolves dependencies strictly, but contributors need corepack (it comes with Node).
