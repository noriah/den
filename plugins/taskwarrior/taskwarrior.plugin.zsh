() {
  emulate -L zsh

  if ! type "task" > /dev/null; then
    zrc_fail "Missing Taskwarrior (task)"
    return
  fi

  zstyle ':completion:*:*:task:*' verbose yes
  zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'

  zstyle ':completion:*:*:task:*' group-name ''

  zrc compdef _task t=task

  local d=$(dirname "${(%):-%x}")
  alias task="TASKRC=\"$d/taskrc\" task"
  alias t=task

}
