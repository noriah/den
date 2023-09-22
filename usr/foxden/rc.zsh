. "$DEN/usr/foxden/base/functions.zsh"

baseSubPath="usr/foxden/base"

den::env::default 'PAGER' 'less'
den::env::default 'LESS' '-R'

den::source "$baseSubPath/alias.zsh"
den::source "$baseSubPath/appearance.zsh"
den::source "$baseSubPath/completion.zsh"
den::source "$baseSubPath/directory.zsh"
den::source "$baseSubPath/history.zsh"
den::source "$baseSubPath/host.zsh"
den::source "$baseSubPath/keys.zsh"
den::source "$baseSubPath/misc.zsh"
den::source "$baseSubPath/terminal.zsh"
den::source "$baseSubPath/user.zsh"

unset baseSubPath

export ZSH_COMP_FILE="$ZSH_CACHE_DIR/zcompdump"

autoload -Uz add-zsh-hook compinit
compinit -d "$ZSH_COMP_FILE"
