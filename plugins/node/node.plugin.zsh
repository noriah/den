() {
  emulate -L zsh

  if ! type "node" > /dev/null; then
    zash_fail "Missing Node"
    return
  fi
}
