#!/usr/bin/env zsh

den::conf() {
  [ -f "$DEN/etc/den/$1" ] && . "$DEN/etc/den/$1"
  return "$?"
}

den::source() {
  if [ -f "$DEN/$1" ]; then
    . "$DEN/$1"
    return 0
  fi
  printf "sorry! i could not find '%s' in '%s'.\n" "$1" "$DEN" 1>&2
  return 1
}

den::env::default() {
  (( ${${(@f):-$(typeset +xg)}[(I)$1]} )) && return 0
  export "$1=$2" && return 3
}

den::export::always() {
  export "$1=$2" && return 0
}

den::export::verbose() {
  local _var="${1}"
  local _val="${2}"

  [[ "$_val" =~ ^"$HOME"(/|$) ]] && _val="~${_val#$HOME}"

  printf "%s=%s\n" "$_var" "$_val"

  den::export::always $@
  local ret=$?

  unset _var
  unset _val

  return $ret
}

# Set the value only if we are in shell level 1
den::export::once() {
  if [ ${DEN_ZSHRC_RUN:=0} -ne 1 ]; then
    den::export::always "$1" "$2"
  fi
}

den::path::add() {
  den::path::check "$1" && return 0
  export PATH="${PATH:+${PATH}:}${1}"
  return 0
}

den::path::check() {
  [[ "$PATH" == *${1}* ]] && return 0 || return 1
}

den::is::mac() {
  [[ $OSTYPE =~ darwin ]] && return 0 || return 1
}

den::is::linux() {
  [[ $OSTYPE =~ linux ]] && return 0 || return 1
}

den::platform::get() {
  case "$OSTYPE" in
    *darwin*) echo "macos" ;;
    *linux*) echo "linux" ;;
  esac
}
