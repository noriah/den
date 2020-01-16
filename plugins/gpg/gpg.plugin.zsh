() {
  emulate -L zsh

  if ! type "todo.sh" > /dev/null; then
    typeset -g ZASH_PLUGIN_FAIL=1
    return
  fi

  typeset -g SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
}

