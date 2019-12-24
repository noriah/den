# ZAsh ZSH framwork
# noriah <code@ashpup.com>
#
# See LICENSE file
function _zash_base() {
  [[ -f "${ZSH_BASE_DIR}/$1.zsh" ]] && source "${ZSH_BASE_DIR}/$1.zsh"
}

function _zash_config() {
  [[ -f "${ZSH_CONF_DIR}/$1.zsh" ]] && source "${ZSH_CONF_DIR}/$1.zsh"
}

function _zash_library() {
  if [[ -d "${ZSH_LIB_DIR}/$1" ]] && [[ -f "${ZSH_LIB_DIR}/$1/$1.lib.zsh" ]]; then
    _zash_config "$1"

    source "${ZSH_LIB_DIR}/$1/$1.lib.zsh"
  fi
}

function _zash_plugin() {
  if [[ -d "${ZSH_PLUGIN_DIR}/$1" ]] && [[ -f "${ZSH_PLUGIN_DIR}/$1/$1.plugin.zsh" ]]; then
    _zash_config "$1"

    source "${ZSH_PLUGIN_DIR}/$1/$1.plugin.zsh"
  fi
}


function zash() {
  local action
  local item

  action="$1"
  item="$2"

  case "$action" in
    "base")
      _zash_base "$item"
      ;;

    "library")
      _zash_library "$item"
      ;;

    "plugin")
      _zash_plugin "$item"
      ;;

    *)
      return
      ;;
  esac
}

function _zash_compinit () {
  autoload -Uz compinit; compinit -C -d "${ZSH_COMP_FILE}";
  add-zsh-hook -D precmd _zash_compinit
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zash_compinit
