#!/usr/bin/env zsh

if [[ ! -v FOX_DEN ]]; then
  printf "*** FOX_DEN variable not set. cannot continue. ***"
  exit 1
fi

source "$FOX_DEN/usr/foxden/setup/fn.zsh"

if den::is::mac; then
  den::install::ensureDir '.vscode/extensions'

  den::install::link '.vscode/extensions/noriah-themes' \
    'usr/vscode/extensions/noriah-themes'

  den::install::ensureDir 'Library/Application Support/Code/User'

  den::install::checkBackupHome 'Library/Application Support/Code/User/settings.json'
  den::install::link 'Library/Application Support/Code/User/settings.json' \
    'usr/vscode/settings/client.json'

  den::install::checkBackupHome 'Library/Application Support/Code/User/keybindings.json'
  den::install::link 'Library/Application Support/Code/User/keybindings.json' \
    'usr/vscode/settings/keybindings.macos.json'

  den::install::checkBackupHome 'Library/Application Support/Code/User/snippets'
  den::install::link 'Library/Application Support/Code/User/snippets' \
    'usr/vscode/snippets'

elif den::is::linux; then
  echo "*** TODO: Linux VSCode client setup. ***"
  exit 1
fi
