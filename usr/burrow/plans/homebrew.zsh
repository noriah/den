den::env::default 'BREW_PATH' '/opt/homebrew'

den::export_once 'PATH' "$PATH:$BREW_PATH/bin"
