() {
  emulate -L zsh

  if ! type "gpg" > /dev/null; then
    zrc_fail "Missing GPG"
    return
  fi

  typeset -g SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
}

