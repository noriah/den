() {
  emulate -L zsh

  if ! type "cargo" > /dev/null; then
    zrc_fail "Missing Cargo"
    return
  fi
}
