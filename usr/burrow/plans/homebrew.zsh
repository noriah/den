env_default 'BREW_PATH' '/opt/homebrew'

export_once 'PATH' "$PATH:$BREW_PATH/bin"
