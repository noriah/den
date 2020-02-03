() {
  emulate -L zsh

  if ! type "cargo" > /dev/null; then
    zash_fail "Missing Cargo"
    return
  fi
}
