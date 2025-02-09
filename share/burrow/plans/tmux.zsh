# tmux stuff

alias ta='tmux attach'

if [[ ! -z "$TMUX" ]]; then

  tmux::window::get() {
    echo $(tmux display -pt "${TMUX_PANE:?}" '#I')
    return 0
  }

  tmux::title::set() {
    # set window name in TTY for faster update
    echo -n -e "\e]0;$@\e\\" > $TTY
    # set window name so it is already set on reconnect
    tmux rename-window -t $(tmux::window::get) "$@"
  }

  tmux::auto::title::set() {
    tmux::title::set "$(basename "`pwd`") $1"
  }

  # Handle tmux on prompt
  tmux::auto::title::precmd() {
    tmux::auto::title::set
  }

  # Handle tmux on command
  tmux::auto::title::preexec() {
    emulate -L zsh
    setopt extended_glob

    # cmd name only, or if this is sudo or ssh, the next cmd
    local _tmux_cmd=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
    # local _tmux_line="${2:gs/%/%%}"

    tmux::auto::title::set "($_tmux_cmd)"

    unset _tmux_cmd
    # unset _tmux_line
  }

  autoload -U add-zsh-hook
  add-zsh-hook precmd tmux::auto::title::precmd
  add-zsh-hook preexec tmux::auto::title::preexec
fi
