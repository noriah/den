() {
  emulate -L zsh

  if ! type "gpg" > /dev/null; then
    zash_fail "Missing GPG"
    return
  fi

  typeset -g SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
}

