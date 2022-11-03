# History
HISTORY="$HOME_VAR/history"

HISTFILE="$HISTORY/zsh"
HISTSIZE=60000
SAVEHIST=30000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history_time
#setopt share_history

export LESSHISTFILE="$HISTORY/less"

