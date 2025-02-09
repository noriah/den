#!/usr/bin/env zsh

if [[ ! -v DEN ]]; then
  printf "*** DEN variable not set. cannot continue. ***"
  exit 1
fi

source "$DEN/share/foxden/setup/fn.zsh"

if den::is::mac; then
  echo "*** UNSUPPORTED: VSCode server on macOS. ***"
  exit 1

elif den::is::linux; then
  den::install::ensureDir '.vscode-server/data/Machine'

  den::install::checkBackupHome '.vscode-server/data/Machine/settings.json'
  den::install::link '.vscode-server/data/Machine/settings.json' \
    'share/vscode/settings/server.json'
fi
