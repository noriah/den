() {
  emulate -L zsh

  if ! type "go" > /dev/null; then
    zash_fail "Missing Go"
    return
  fi
}
