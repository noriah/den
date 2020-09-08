# Zrc ZSH framwork
# noriah <vix@noriah.dev>
#
# See LICENSE file

typeset -g _zrc_plugin_list=()
typeset -g _zrc_ext_fail=()
typeset -g _zrc_internal_fail=()
typeset -ga _zrc_hook_list=()
typeset -ga _zrc_compdef_list=()
typeset -g _zrc_post_compdef_list=()

typeset -g _zrc_ret_dir

typeset -g ZRC_BASE_DIR="${0:h:A}"

zrc_has_plugin() {
  [[ ${_zrc_plugin_list[(ie)$1]} -le ${#_zrc_plugin_list} ]] && return 0 || return 1
}

_zrc_base() {
  [[ -f "$ZSH_BASE_DIR/$1.zsh" ]] && source "$ZSH_BASE_DIR/$1.zsh"
}

_zrc_config() {
  [[ -f "$ZSH_CONF_DIR/$1.zsh" ]] && source "$ZSH_CONF_DIR/$1.zsh"
}

_zrc_library() {
  [[ -d "$ZSH_LIB_DIR/$1" && -f "$ZSH_LIB_DIR/$1/$1.lib.zsh" ]] || return 1
  _zrc_config "$1"
  source "$ZSH_LIB_DIR/$1/$1.lib.zsh" || return 1
}

_zrc_ensure_dir() {
  local d="$ZRC_BASE_DIR/$1"
  [[ -d "$d" ]] || mkdir -p "$d"
  _zrc_ret_dir="$d"
}

_zrc_fail_int() {
  if [[ -z "$1" ]] then
    _zrc_internal_fail+=("internal (Zrc) failure")
  else
    _zrc_internal_fail+=("$@")
  fi
}

_zrc_assert_cmd() {
  if ! type "$1" > /dev/null; then
    _zrc_fail_int "$1 not found, Check PATH"
    return 1
  fi
  return 0
}

zrc_plugin_require_command() {
  if ! type "node" > /dev/null; then
    zrc_fail "Missing Node"
    return
  fi
}

_zrc_int_fail_check() {
  [[ -z "$_zrc_internal_fail" ]] && return 0
  printf "Zrc: failed to process '%s' %s:\n" "$1" "$2" >&2
  for i in $_zrc_internal_fail; do
    printf "  -> %s\n" "$i" >&2
  done
  printf "\n" >&2
  return 1
}

zrc_fail() {
  if [[ -z "$1" ]] then
    _zrc_ext_fail+=("failed during load")
  else
    _zrc_ext_fail+=("$@")
  fi
}

_zrc_ext_fail_reset() {
  _zrc_ext_fail=()
}

_zrc_ext_fail_check() {
  [[ -z "$_zrc_ext_fail" ]] && return 0
  printf "Zrc: failed to process '%s' %s:\n" "$1" "$2" >&2
  for i in $_zrc_ext_fail; do
    printf "  -> %s\n" "$i" >&2
  done
  printf "\n" >&2
  return 1
}

_zrc_init() {
  _zrc_ensure_dir fetched
}

_zrc_fetch_github() {
  local repo_name="$1"
  [[ -z "$2" ]] || shift
  local repo_dest="$1"

  _zrc_ensure_dir ".fetched/$repo_dest"

  [[ -d "$_zrc_ret_dir/.git" ]] || _zrc_fetch_git_repo_clone "https://github.com/${repo_name}.git" "$_zrc_ret_dir"
}

_zrc_fetch_git_repo_clone() {
  printf "Downloading '%s'...\n" "$1"
  git clone "$1" "$2" && echo "done!" || echo "fail!"
}

_zrc_plugin() {
  local name="$1"

  [[ -z "$2" ]] || shift
  local package="$@"

  local pdir="$ZSH_PLUGIN_DIR/$package"
  ZSH_CURRENT_PLUGIN_DIR=${pdir}

  [[ -d "$pdir" && -f "$pdir/$name.plugin.zsh" ]] || return 1
  _zrc_config "$name"

  _zrc_ext_fail_reset

  source "$pdir/$name.plugin.zsh" || zrc_fail "sourcing error"

  _zrc_ext_fail_check "$name" "plugin" || return 1

  fpath=($pdir $fpath)
  _zrc_plugin_list+=("$name")
}


_zrc_plugins() {
  while read i
  do
    [[ "$i" != "#*" ]] && _zrc_plugin "$i"
  done < "$1"
}

_zrc_do_autoload() {
  autoload -Uz add-zsh-hook compinit
}

_zrc_do_compinit() {
  compinit -C -d "$ZSH_COMP_FILE"
}

_zrc_do_clean() {
  rm "$ZSH_COMP_FILE"
}

_zrc_do_hooks() {
  local a='' b=''
  for a b in "${_zrc_hook_list[@]}"; do
    add-zsh-hook "$a" "$b"
  done

  add-zsh-hook precmd _zrc_hook_compinit
  add-zsh-hook precmd _zrc_hook_compdef
}

_zrc_hook_compdef() {
  local a=''
  for a in "${_zrc_compdef_list[@]}"; do
    compdef $a
  done

  for a in "${_zrc_post_compdef_list[@]}"; do
    $a
  done

  add-zsh-hook -D precmd _zrc_hook_compdef
}

_zrc_add_hook() {
  _zrc_hook_list+=("$1" "$2")
}

_zrc_add_compdef() {
  _zrc_compdef_list+=("$@")
}

_zrc_add_post_compdef() {
  _zrc_post_compdef_list+=("$@")
}

_zrc_hook_compinit() {
  _zrc_do_compinit
  add-zsh-hook -D precmd _zrc_hook_compinit
}

zrc() {
  local action="$1"
  local item="$2"
  shift 2

  case "$action" in
    init)
      _zrc_init
      ;;

    fetch)
      case "$item" in
        github|repo)
          _zrc_fetch_github "$@"
          ;;

        *)
          return
          ;;
      esac
      ;;

    "base")
      _zrc_base "$item"
      ;;

    "library")
      _zrc_library "$item"
      ;;

    "plugin")
      _zrc_plugin "$item" "$@"
      ;;

    "plugins")
      _zrc_plugins "$item"
      ;;

    "compdef")
      _zrc_add_compdef "$item"
      ;;

    "postcompdef")
      _zrc_add_post_compdef "$item"
      ;;

    "hook")
      _zrc_add_hook "$item" "$@"
      ;;

    "do")
      case "$item" in
        "autoload")
          _zrc_do_autoload
          ;;

        "clean")
          _zrc_do_clean
          ;;

        "compinit")
          _zrc_do_compinit
          ;;

        hook*)
          _zrc_do_hooks
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
