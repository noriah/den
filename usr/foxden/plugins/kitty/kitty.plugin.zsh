() {
  emulate -L zsh

  if ! type "kitty" > /dev/null; then
    zrc_fail "Missing kitty"
    return
  fi

  _kitty_init_compdef() {
    kitty + complete setup zsh | source /dev/stdin
  }

  zrc postcompdef _kitty_init_compdef
}
