() {
  emulate -L zsh

  if ! type "todo.sh" > /dev/null; then
    typeset -g ZASH_PLUGIN_FAIL="todo.sh not found!"
    return
  fi
}
