_GIT_CONFIG_FILENAME=.gitconfig

typeset -g GIT_CONFIG

_git_find_gitconfig () {
  local look_from=${1:-$PWD}
  local look_until=${${2:-~/}:A}
  local look_for=$_GIT_CONFIG_FILENAME

  local last
  local parent_dir="$look_from/.."
  local abs_parent_dir
  while true; do
    abs_parent_dir=${parent_dir:A}
    if [[ $abs_parent_dir == $last ]]; then
      break
    fi
    local parent_file="${parent_dir}/${look_for}"

    if [[ -f $parent_file ]]; then
      if [[ ${parent_file[1,2]} == './' ]]; then
        echo ${parent_file#./}
      else
        echo ${parent_file:a}
      fi
      break
    fi

    if [[ $abs_parent_dir == $look_until ]]; then
      break
    fi
    last=$abs_parent_dir
    parent_dir="${parent_dir}/.."
  done
}

_git_chpwd_handler() {
  emulate -L zsh

  if [ "${PWD:A}" = "${HOME:A}" ]; then
    unset GIT_CONFIG
    return
  fi

  if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    unset GIT_CONFIG
    return
  fi

  local conf_file="$PWD/$_GIT_CONFIG_FILENAME"

  if ! [[ -f $conf_file ]]; then
    conf_file=$(_git_find_gitconfig $PWD)
    if [[ -z $conf_file ]]; then
      unset GIT_CONFIG
      return
    fi
  fi

  export GIT_CONFIG="$conf_file"
}

() {
  emulate -L zsh

  if ! type "git" > /dev/null; then
    zrc_fail "Missing git"
    return
  fi

  zrc hook chpwd _git_chpwd_handler

  _git_chpwd_handler
}
