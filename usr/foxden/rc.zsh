. "$FOX_DEN/usr/foxden/fn.zsh"

baseSubPath="usr/foxden/base"

den::source "$baseSubPath/functions.zsh"

env_default 'PAGER' 'less'
env_default 'LESS' '-R'

den::source "$baseSubPath/alias.zsh"
den::source "$baseSubPath/appearance.zsh"
den::source "$baseSubPath/completion.zsh"
den::source "$baseSubPath/directory.zsh"
den::source "$baseSubPath/history.zsh"
den::source "$baseSubPath/keys.zsh"
den::source "$baseSubPath/misc.zsh"
den::source "$baseSubPath/terminal.zsh"

unset baseSubPath

autoload -Uz add-zsh-hook compinit

export ZSH_COMP_FILE="$ZSH_CACHE_DIR/zcompdump"

compinit -C -d "$ZSH_COMP_FILE"
