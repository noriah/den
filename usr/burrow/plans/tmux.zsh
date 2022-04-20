# tmux stuff

alias ta='tmux attach'

if [[ ! -z "$TMUX" ]]; then

  # set tmux window environment variable from this shell
  export TMUX_WINDOW=$(tmux display -pt "${TMUX_PANE:?}" '#I')

  tmux_title_set() {
    # set window name in TTY for faster update
    echo -n -e "\e]0;$@\e\\" > $TTY
    # set window name so it is already set on reconnect
    tmux rename-window -t $TMUX_WINDOW "$@"
  }

  tmux_auto_title_set() {
    tmux_title_set "$(basename "`pwd`")$1"
  }

  tmux_auto_title_precmd() {
    tmux_auto_title_set
  }

  tmux_auto_title_preexec() {
    emulate -L zsh
    setopt extended_glob

    # cmd name only, or if this is sudo or ssh, the next cmd
    local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
    local LINE="${2:gs/%/%%}"

    tmux_auto_title_set " ($CMD)"
  }

  autoload -U add-zsh-hook
  add-zsh-hook precmd tmux_auto_title_precmd
  add-zsh-hook preexec tmux_auto_title_preexec

fi
