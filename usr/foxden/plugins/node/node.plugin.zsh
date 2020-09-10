() {
  emulate -L zsh

  if ! type "node" > /dev/null; then
    zrc_fail "Missing Node"
    return
  fi
}
