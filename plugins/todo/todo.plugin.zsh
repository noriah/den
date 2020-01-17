() {
  emulate -L zsh

  if ! type "todo.sh" > /dev/null; then
    zash_fail "Missing todo.sh"
    return
  fi
}
