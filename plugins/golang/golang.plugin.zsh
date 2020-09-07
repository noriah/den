() {
  emulate -L zsh

  if ! type "go" > /dev/null; then
    zrc_fail "Missing Go"
    return
  fi
}
