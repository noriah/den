#!/usr/bin/env zsh

den::conf() {
  [ -f "$FOX_DEN/etc/den/$1" ] && . "$FOX_DEN/etc/den/$1"
  return "$?"
}

den::source() {
  if [ -f "$FOX_DEN/$1" ]; then
    . "$FOX_DEN/$1"
    return 0
  fi
  printf "sorry! i could not find '%s' in '%s'.\n" "$1" "$FOX_DEN" 1>&2
  return 1
}

den::env::default() {
  (( ${${(@f):-$(typeset +xg)}[(I)$1]} )) && return 0
  export "$1=$2" && return 3
}

den::export::always() {
  export "$1=$2" && return 0
}

# Set the value only if we are in shell level 1
den::export::once() {
  if [ ${FOX_DEN_ZSHRC_RUN:=0} -ne 1 ]; then
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
