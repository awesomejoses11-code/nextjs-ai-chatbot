#!/usr/bin/env bash
# Installs the pinned CCTools campaign prerelease of canton-devkit
# (v0.18.2-cctools.1) — NOT the regular release. The normal installer
# and Homebrew deliberately do not enable campaign mode.
# Source: https://github.com/bitdynamics-ab/canton-devkit/blob/v0.18.2-cctools.1/docs%2Fcctools-campaign.md
set -euo pipefail

curl -fsSL https://raw.githubusercontent.com/bitdynamics-ab/canton-devkit/v0.18.2-cctools.1/install.sh \
  | VERSION=0.18.2-cctools.1 sh

export PATH="$HOME/.local/bin:$PATH"

# Must show v0.18.2-cctools.1, a commit ID matching BUILD-INFO.txt,
# and "campaign code: CCT-XXXXXXXX" (your actual code will differ).
canton-devkit version

# Back up the campaign code into the workspace. It lives in
# ~/.canton-devkit/campaign-id, outside the repo — if the Codespace
# is ever rebuilt, that file is gone. This copy is git-ignored
# (see .gitignore); do not commit it to a public repo.
if [ -f "$HOME/.canton-devkit/campaign-id" ]; then
  cp "$HOME/.canton-devkit/campaign-id" ./campaign-id-backup.txt
  echo "Campaign code backed up to ./campaign-id-backup.txt"
else
  echo "WARNING: no campaign-id file found at ~/.canton-devkit/campaign-id" >&2
fi

echo ""
echo "Next: canton-devkit localnet doctor"
echo "Then: canton-devkit localnet up cctools-demo"
