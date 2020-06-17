() {
  emulate -L zsh

  if ! type "task" > /dev/null; then
    zash_fail "Missing Taskwarrior (task)"
    return
  fi

  zstyle ':completion:*:*:task:*' verbose yes
  zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'

  zstyle ':completion:*:*:task:*' group-name ''

  alias t=task
  zash compdef _task t=task
}
