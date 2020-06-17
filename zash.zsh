# ZAsh ZSH framwork
# noriah <vix@noriah.dev>
#
# See LICENSE file

typeset -g _zash_plugin_list=()
typeset -g _zash_ext_fail=()
typeset -g _zash_internal_fail=()
typeset -ga _zash_hook_list=()
typeset -ga _zash_compdef_list=()

typeset -g _zash_ret_dir

typeset -g ZASH_BASE_DIR="${0:h:A}"

zash_has_plugin() {
  [[ ${_zash_plugin_list[(i)$1]} -le ${#_zash_plugin_list} ]] && return 1 || return 0
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

_zash_ensure_dir() {
  local d="$ZASH_BASE_DIR/$1"
  [[ -d "$d" ]] || mkdir -p "$d"
  _zash_ret_dir="$d"
}

_zash_fail_int() {
  if [[ -z "$1" ]] then
    _zash_internal_fail+=("internal (Zash) failure")
  else
    _zash_internal_fail+=("$@")
  fi
}

_zash_assert_cmd() {
  if ! type "$1" > /dev/null; then
    _zash_fail_int "$1 not found, Check PATH"
    return 1
  fi
  return 0
}

_zash_int_fail_check() {
  [[ -z "$_zash_internal_fail" ]] && return 0
  printf "Zash: failed to process '%s' %s:\n" "$1" "$2" >&2
  for i in $_zash_internal_fail; do
    printf "  -> %s\n" "$i" >&2
  done
  printf "\n" >&2
  return 1
}

zash_fail() {
  if [[ -z "$1" ]] then
    _zash_ext_fail+=("failed during load")
  else
    _zash_ext_fail+=("$@")
  fi
}

_zash_ext_fail_reset() {
  _zash_ext_fail=()
}

_zash_ext_fail_check() {
  [[ -z "$_zash_ext_fail" ]] && return 0
  printf "Zash: failed to process '%s' %s:\n" "$1" "$2" >&2
  for i in $_zash_ext_fail; do
    printf "  -> %s\n" "$i" >&2
  done
  printf "\n" >&2
  return 1
}

_zash_init() {
  _zash_ensure_dir fetched
}

_zash_fetch_github() {
  local repo_name="$1"
  [[ -z "$2" ]] || shift
  local repo_dest="$1"

  _zash_ensure_dir ".fetched/$repo_dest"

  [[ -d "$_zash_ret_dir/.git" ]] || _zash_fetch_git_repo_clone "https://github.com/${repo_name}.git" "$_zash_ret_dir"
}

_zash_fetch_git_repo_clone() {
  printf "Downloading '%s'...\n" "$1"
  git clone "$1" "$2" && echo "done!" || echo "fail!"
}

_zash_plugin() {
  local name="$1"

  [[ -z "$2" ]] || shift
  local package="$@"

  local pdir="$ZSH_PLUGIN_DIR/$package"
  ZSH_CURRENT_PLUGIN_DIR=${pdir}

  [[ -d "$pdir" && -f "$pdir/$name.plugin.zsh" ]] || return 1
  _zash_config "$name" 

  _zash_ext_fail_reset

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

_zash_do_hooks() {
  local a='' b=''
  for a b in "${_zash_hook_list[@]}"; do
    add-zsh-hook "$a" "$b"
  done

  add-zsh-hook precmd _zash_hook_compinit
  add-zsh-hook precmd _zash_hook_compdef
}

_zash_hook_compdef() {
  local a=''
  for a in "${_zash_compdef_list[@]}"; do
    compdef $a
  done
  add-zsh-hook -D precmd _zash_hook_compdef
}

_zash_add_hook() {
  _zash_hook_list+=("$1" "$2")
}

_zash_add_compdef() {
  _zash_compdef_list+=("$@")
}

_zash_hook_compinit() {
  _zash_do_compinit
  add-zsh-hook -D precmd _zash_hook_compinit
}

zash() {
  local action="$1"
  local item="$2"
  shift 2

  case "$action" in
    init)
      _zash_init
      ;;

    fetch)
      case "$item" in
        github|repo)
          _zash_fetch_github "$@"
          ;;

        *)
          return
          ;;
      esac
      ;;

    "base")
      _zash_base "$item"
      ;;

    "library")
      _zash_library "$item"
      ;;

    "plugin")
      _zash_plugin "$item" "$@"
      ;;

    "plugins")
      _zash_plugins "$item"
      ;;

    "compdef")
      _zash_add_compdef "$@"
      ;;

    "hook")
      _zash_add_hook "$item" "$@"
      ;;

    "do")
      case "$item" in
        "autoload")
          _zash_do_autoload
          ;;

        "clean")
          _zash_do_clean
          ;;

        "compinit")
          _zash_do_compinit
          ;;

        hook*)
          _zash_do_hooks
          ;;

        *)
          return
          ;;
      esac
      ;;

    *)
      return
      ;;
  esac
}
