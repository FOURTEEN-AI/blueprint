# 0104. Devcontainer tools come from official sources, not community features

- Status: Accepted
- Date: 2026-10-15
- Extends: [0081](0081-pnpm-standalone-without-corepack.md) (replaces "a devcontainer feature locally" for pnpm)

## Context

ADR 0081 installs pnpm locally through a devcontainer feature. The only pnpm feature is in `devcontainers-extra/features`, a community collection outside the official `devcontainers` organization. It continues the former `devcontainers-contrib` project, whose old account is now a fork warning users to restrict its use. The pnpm feature downloads the maintainers' `nanolayer` tool (a repository last updated in 2024), which runs a second feature of the collection to execute `npm install -g pnpm`. The same is true for `flyctl`: the only features are small community projects, the one we looked at last updated in 2023.

Devcontainer features run as **root** while the container is built. Agents work in that container with the human's GitHub credentials (ADR 0088).

## Decision

- The devcontainer uses features **only from the official `devcontainers` organization** and from tool vendors themselves (e.g. Anthropic's Claude Code feature).
- Other tools are installed by **`.devcontainer/post-create.sh`** from official sources, as the remote user, not root:
  - **pnpm** with `npm install -g pnpm`, after Node has been switched to the version in `.node-version`. Any pnpm version works, because pnpm switches to the version pinned in `packageManager` (ADR 0081).
  - **flyctl** with Fly's official installer.

## Consequences

- No third-party code runs as root during the build, and no extra download tool is involved.
- Dependabot doesn't update tools installed by the script. pnpm follows `packageManager`, and flyctl updates itself, so nothing is pinned there that could go stale.
- **Rejected:** the `devcontainers-extra` pnpm feature and the community `flyctl` features, because they add third-party artifacts that run as root for what is a single install command.
