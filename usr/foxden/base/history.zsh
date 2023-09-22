# History
HISTORY_ROOT="${HOME_VAR}/history"

export HISTORY="$HISTORY_ROOT/default"

[[ -d "$HISTORY" ]] || mkdir -p "$HISTORY"

export HISTFILE="$HISTORY/zsh"
export HISTSIZE=60000
export SAVEHIST=60000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history_time
#setopt share_history

export LESSHISTFILE="$HISTORY/less"

