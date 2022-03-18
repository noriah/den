#!/usr/bin/env zsh

if [[ ! -v FOX_DEN ]]; then
  printf "*** FOX_DEN variable not set. cannont continue. ***"
  exit 1
fi

source "$FOX_DEN/usr/foxden/setup/fn.zsh"

if [[ $OSTYPE =~ darwin ]]; then
  echo "*** UNSUPPORTED: VSCode server on macOS. ***"
  exit 1

elif [[ $OSTYPE =~ linux ]]; then
  ensureDir '.vscode-server/data/Machine'

  checkBackupHome '.vscode-server/data/Machine/settings.json'
  linkDen '.vscode-server/data/Machine/settings.json' \
    'usr/vscode/settings/server.json'
fi
