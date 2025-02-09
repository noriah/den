#!/share/bin/env zsh

if [[ ! -v DEN ]]; then
  printf "*** DEN variable not set. cannot continue. ***"
  exit 1
fi

source "$DEN/share/foxden/setup/fn.zsh"

if den::is::mac; then
  den::install::ensureDir '.vscode/extensions'

  den::install::link '.vscode/extensions/noriah-themes' \
    'share/vscode/extensions/noriah-themes'

  den::install::ensureDir 'Library/Application Support/Code/User'

  den::install::checkBackupHome 'Library/Application Support/Code/User/settings.json'
  den::install::link 'Library/Application Support/Code/User/settings.json' \
    'share/vscode/settings/client.json'

  den::install::checkBackupHome 'Library/Application Support/Code/User/keybindings.json'
  den::install::link 'Library/Application Support/Code/User/keybindings.json' \
    'share/vscode/settings/keybindings.macos.json'

  den::install::checkBackupHome 'Library/Application Support/Code/User/snippets'
  den::install::link 'Library/Application Support/Code/User/snippets' \
    'share/vscode/snippets'

elif den::is::linux; then
  local _extDir='.vscode/extensions'
  local _confDir='.config/Code/User'

  den::install::ensureDir $_extDir

  den::install::link "$_extDir/noriah-themes" \
    'share/vscode/extensions/noriah-themes'

  den::install::ensureDir "$_extDir"

  den::install::checkBackupHome "$_confDir/settings.json"
  den::install::link "$_confDir/settings.json" \
    'share/vscode/settings/client.json'

  den::install::checkBackupHome "$_confDir/keybindings.json"
  den::install::link "$_confDir/keybindings.json" \
    'share/vscode/settings/keybindings.linux.json'

  den::install::checkBackupHome "$_confDir/snippets"
  den::install::link "$_confDir/snippets" \
    'share/vscode/snippets'

  unset _extDir
  unset _confDir
fi
