#!/usr/bin/env zsh

if [[ ! -v FOX_DEN ]]; then
  printf "*** FOX_DEN variable not set. cannot continue. ***"
  exit 1
fi

source "$FOX_DEN/usr/foxden/setup/fn.zsh"

if isMac; then
  echo "*** UNSUPPORTED: VSCode server on macOS. ***"
  exit 1

elif isLinux; then
  ensureDir '.vscode-server/data/Machine'

  checkBackupHome '.vscode-server/data/Machine/settings.json'
  linkDen '.vscode-server/data/Machine/settings.json' \
    'usr/vscode/settings/server.json'
fi
