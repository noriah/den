# ZAsh ZSH framwork
# noriah <code@ashpup.com>
#
# See LICENSE file

ZASH_PLUGINS=()

function zash_has_plugin() {
  local item
  item="$1"
  return (( ${ZASH_PLUGINS[(r)$item]} ))
}

function zash() {
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
    local pdir
    local item
    item="$1"
    pdir="${ZSH_PLUGIN_DIR}/$item"
    if [[ -d "$pdir" ]] && [[ -f "$pdir/$item.plugin.zsh" ]]; then
      _zash_config "$1"

      typeset -g fpath=($pdir $fpath)
      typeset -g ZASH_PLUGINS=($ZASH_PLUGINS $item)
      source "$pdir/$item.plugin.zsh"
    fi
  }


  function _zash_plugins() {
    while read i
    do
      _zash_plugin "$i"
    done < "$1"
  }

  function _zash_do_autoload() {
    autoload -Uz add-zsh-hook compinit
  }

  function _zash_do_compinit() {
    compinit -C -d "${ZSH_COMP_FILE}"
  }

  function _zash_do_clean() {
    rm "${ZSH_COMP_FILE}"
  }

  function _zash_do_hook() {
    function _zash_hook_compinit () {
      _zash_do_compinit
      add-zsh-hook -D precmd _zash_hook_compinit
    }

    add-zsh-hook precmd _zash_hook_compinit
  }

  function _zash_do() {
    local action

    action="$1"

    case "$action" in
      "autoload")
        _zash_do_autoload
        ;;

      "clean")
        _zash_do_clean
        ;;

      "compinit")
        _zash_do_compinit
        ;;

      "hook")
        _zash_do_hook
        ;;

      *)
        return
        ;;
    esac
  }

  local action
  local item

  action="$1"
  item="$2"
  extra="${@:3}"

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

    "plugins")
      _zash_plugins "$item"
      ;;

    "do")
      _zash_do "$item"
      ;;

    *)
      return
      ;;
  esac
}
