() {
  emulate -L zsh

  if ! type "task" > /dev/null; then
    zash_fail "Missing Taskwarrior (task)"
    return
  fi
}
