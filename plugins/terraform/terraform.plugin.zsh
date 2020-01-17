() {
  emulate -L zsh

  if ! type "terraform" > /dev/null; then
    zash_fail "Missing terraform binary"
    return
  fi
}
