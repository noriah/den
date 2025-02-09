#!/usr/bin/env zsh

den::install::checkExists() {
  if [ -e "$2/$1" ]; then
    echo "'$1' already exists in '$2'. can not continue."
    echo "no changes made."
    exit 1
  fi
}

den::install::checkBackupHome() {
  if [ -e "$HOME/$1" ]; then
    echo "replacing '$HOME/$1' (backup in '$HOME/$1.old')"
    mv "$HOME/$1" "$HOME/$1.old"
  fi
}

den::install::checkRmHome() {
  if [ -f "$HOME/$1" ]; then
    echo "removing '$HOME/$1'"
    rm "$HOME/$1"
  else
    echo "noop ('$1')"
  fi
}

den::install::ensureDir() {
  if [ ! -d "$HOME/$1" ]; then
    echo "creating directory(s) '$HOME/$1'."
    mkdir -p "$HOME/$1"
  fi
}

den::install::link() {
  local _path="$1"
  if [ $# -eq 2 ]; then
    shift
  fi

  local _target="$DEN/$1"

  if [[ $1 =~ (etc|share)/(.+) ]]; then
    case "${match[1]}" in
      etc) _target="$HOME_ETC/${match[2]}" ;;
      share) _target="$HOME_SHARE/${match[2]}" ;;
    esac
  fi

  echo "creating symlink '$HOME/${_path}' -> '${_target}'"
  ln -s "${_target}" "$HOME/${_path}"

  unset _path
  unset _target
}

den::install::source() {
  den::install::checkBackupHome ".$1"

  echo "sourcing '$HOME/.$1' from '$DEN/etc/zsh/$1'"
  echo ". \"$DEN/etc/zsh/$1\"" > "$HOME/.$1"
}

den::is::mac() {
  [[ $OSTYPE =~ darwin ]] && return 0 || return 1
}

den::is::linux() {
  [[ $OSTYPE =~ linux ]] && return 0 || return 1
}

den::is::nixos() {
  den::is::linux || return 1
  grep -q 'NAME=NixOS' /etc/os-release && return 0 || return 1
}

den::platform::get() {
  case "$OSTYPE" in
    *darwin*) echo "macos" ;;
    *linux*) echo "linux" ;;
  esac
}
