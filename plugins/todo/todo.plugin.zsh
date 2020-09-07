() {
  emulate -L zsh

  if ! type "todo.sh" > /dev/null; then
    zrc_fail "Missing todo.sh"
    return
  fi
}
