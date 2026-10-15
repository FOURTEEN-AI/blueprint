# 0081. pnpm installed standalone, without corepack

- Status: Accepted
- Date: 2026-10-15
- Extends: [0006](0006-single-gradle-project-groovy-dsl-pnpm.md) (replaces "enabled through corepack")

## Context

ADR 0006 enables pnpm through corepack, assuming corepack comes with Node. The Node.js Technical Steering Committee stopped distributing corepack starting with **Node.js 25**. Node 24 still bundles it, but every later Node upgrade would break the setup.

## Decision

- **pnpm is installed directly**: a devcontainer feature locally, `pnpm/action-setup` in CI.
- The exact pnpm version is pinned in `package.json`'s **`packageManager`** field. pnpm 10 switches to that version on its own (`manage-package-manager-versions`), so any installed pnpm works.
- The Node version is pinned in **`.node-version`**, which the devcontainer and `actions/setup-node` read.
- corepack is not used anywhere.

## Consequences

- The setup works on any current Node version and doesn't depend on a tool Node has dropped.
- Contributors need pnpm installed. The devcontainer provides it.
- **Rejected:**
  - Installing corepack from npm, because it keeps a dependency on a tool Node itself has given up.
  - Pinning Node 24 to keep the bundled corepack, because it only postpones the problem.
  - Downloading Node and pnpm through a Gradle plugin, because the Vite dev loop (ADR 0007) would then need a separate install anyway.
