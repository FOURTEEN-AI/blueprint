#!/usr/bin/env bash
# Installs what devcontainer features can't: the Node version pinned in
# .node-version (ADR 0081) and flyctl for /bootstrap (ADR 0047).
set -eo pipefail

# Node: switch the node feature's nvm to the pinned version. Global packages
# installed by features (Claude Code, pnpm) are carried over to it.
source "$NVM_DIR/nvm.sh"
wanted="$(tr -d '[:space:]' < .node-version)"
if [ "$(nvm version "$wanted")" = "N/A" ]; then
  nvm install "$wanted" --reinstall-packages-from=current
fi
nvm alias default "$wanted"
nvm use default

# flyctl: Fly's official installer, into ~/.fly/bin (on PATH via remoteEnv).
curl -fsSL https://fly.io/install.sh | sh
