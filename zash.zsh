# ZAsh ZSH framwork
# noriah <vix@noriah.dev>
#
# See LICENSE file

typeset -g _zash_plugin_list=()
typeset -g _zash_ext_fail=()

zash_has_plugin() {
  [[ ${_zash_plugin_list[(i)$1]} -le ${#_zash_plugin_list} ]] && return 0
  return 1
}

_zash_base() {
  [[ -f "$ZSH_BASE_DIR/$1.zsh" ]] && source "$ZSH_BASE_DIR/$1.zsh"
}

_zash_config() {
  [[ -f "$ZSH_CONF_DIR/$1.zsh" ]] && source "$ZSH_CONF_DIR/$1.zsh"
}

_zash_library() {
  [[ -d "$ZSH_LIB_DIR/$1" && -f "$ZSH_LIB_DIR/$1/$1.lib.zsh" ]] || return 1
  _zash_config "$1"
  source "$ZSH_LIB_DIR/$1/$1.lib.zsh" || return 1
}

zash_fail() {
  if [[ -z "$1" ]] then
    _zash_ext_fail+=("Failed during load")
  else
    _zash_ext_fail+=("$@")
  fi
}

_zash_ext_fail_check() {
  [[ -z "$_zash_ext_fail" ]] && return 0
  printf "Zash: Failed to process '%s' %s:\n" "$1" "$2" >&2
  for i in $_zash_ext_fail; do
    printf "  -> %s\n" "$i" >&2
  done
  printf "\n" >&2
  return 1
}

_zash_plugin() {
  local name="$1"

  [[ -z "$2" ]] || shift
  local package="$@"

  local pdir="$ZSH_PLUGIN_DIR/$package"

  [[ -d "$pdir" && -f "$pdir/$name.plugin.zsh" ]] || return 1
  _zash_config "$name"

  _zash_ext_fail=()

  source "$pdir/$name.plugin.zsh" || zash_fail "sourcing error"

  _zash_ext_fail_check "$name" "plugin" || return 1

  fpath=($pdir $fpath)
  _zash_plugin_list+=("$item")
}


_zash_plugins() {
  while read i
  do
    [[ "$i" != "#*" ]] && _zash_plugin $i
  done < "$1"
}

_zash_do_autoload() {
  autoload -Uz add-zsh-hook compinit
}

_zash_do_compinit() {
  compinit -C -d "$ZSH_COMP_FILE"
}

_zash_do_clean() {
  rm "$ZSH_COMP_FILE"
}

_zash_do_hook() {
  _zash_hook_compinit () {
    _zash_do_compinit
    add-zsh-hook -D precmd _zash_hook_compinit
  }

  add-zsh-hook precmd _zash_hook_compinit
}

_zash_do() {
  case "$1" in
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

zash() {
  local action="$1"
  local item="$2"
  local extra="${@:3}"

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
