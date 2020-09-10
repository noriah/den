() {
  emulate -L zsh

  if ! type "terraform" > /dev/null; then
    zrc_fail "Missing terraform binary"
    return
  fi
}
