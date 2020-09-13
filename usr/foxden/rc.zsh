baseSubPath="usr/foxden/base"

denSource "$baseSubPath/functions.zsh"

env_default 'PAGER' 'less'
env_default 'LESS' '-R'

denSource "$baseSubPath/alias.zsh"
denSource "$baseSubPath/appearance.zsh"
denSource "$baseSubPath/completion.zsh"
denSource "$baseSubPath/directory.zsh"
denSource "$baseSubPath/history.zsh"
denSource "$baseSubPath/keys.zsh"
denSource "$baseSubPath/misc.zsh"
denSource "$baseSubPath/terminal.zsh"

unset baseSubPath

autoload -Uz add-zsh-hook compinit
