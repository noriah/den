ZSH_CACHE_DIR="$HOME/.cache/zsh"

[ ! -d "$ZSH_CACHE_DIR" ] && mkdir -p "$ZSH_CACHE_DIR"

ZSH_COMP_FILE="$ZSH_CACHE_DIR/.zcompdump"

fnPath="${0:h:A}/fn"

fpath=("$fnPath" "${fpath[@]}")

for func in $^fnPath/*; do
	autoload -Uz $func
done

unset fnPath

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
