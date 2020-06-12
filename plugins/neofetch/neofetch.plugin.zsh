() {
  emulate -L zsh

  if ! type "neofetch" > /dev/null; then
    zash_fail "Missing neofetch"
    return
  fi

  local d=$(dirname "${(%):-%x}")
  alias neofetch="neofetch --config \"$d/config.conf\" --ascii \"$d/lambda.txt\" --ascii_colors 208 8 208"
}
