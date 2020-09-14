# History
HISTORY="$HOME/var/history"

HISTFILE="$HISTORY/zsh"
HISTSIZE=50000
SAVEHIST=50000

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
#setopt share_history
