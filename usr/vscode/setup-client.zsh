#!/usr/bin/env zsh

if [[ ! -v FOX_DEN ]]; then
  printf "*** FOX_DEN variable not set. cannont continue. ***"
  exit 1
fi

source "$FOX_DEN/usr/foxden/setup/fn.zsh"

if isMac; then
  ensureDir '.vscode/extensions'

  linkDen '.vscode/extensions/noriah-themes' \
    'usr/vscode/extensions/noriah-themes'

  ensureDir 'Library/Application Support/Code/User'

  checkBackupHome 'Library/Application Support/Code/User/settings.json'
  linkDen 'Library/Application Support/Code/User/settings.json' \
    'usr/vscode/settings/client.json'

  checkBackupHome 'Library/Application Support/Code/User/keybindings.json'
  linkDen 'Library/Application Support/Code/User/keybindings.json' \
    'usr/vscode/settings/keybindings.macos.json'

  checkBackupHome 'Library/Application Support/Code/User/snippets'
  linkDen 'Library/Application Support/Code/User/snippets' \
    'usr/vscode/snippits'

elif isLinux; then
  echo "*** TODO: Linux VSCode client setup. ***"
  exit 1
fi
