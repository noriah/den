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
