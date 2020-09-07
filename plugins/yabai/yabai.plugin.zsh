() {
  emulate -L zsh

  if ! type "yabai" > /dev/null; then
    zrc_fail "Missing yabai"
    return
  fi
}
