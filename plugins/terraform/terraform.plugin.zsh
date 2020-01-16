() {
  emulate -L zsh

  if ! type "terraform" > /dev/null; then
    typeset -g ZASH_PLUGIN_FAIL="Terraform binary not found!"
    return
  fi
}
