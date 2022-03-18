#!/usr/bin/env zsh

denConf() {
  [ -f "$FOX_DEN/etc/den/$1" ] && . "$FOX_DEN/etc/den/$1"
  return "$?"
}

denSource() {
  if [ -f "$FOX_DEN/$1" ]; then
    . "$FOX_DEN/$1"
    return 0
  fi
  printf "sorry! i could not find '%s' in '%s'.\n" "$1" "$FOX_DEN" 1>&2
  return 1
}

denAsk() {
  local action="$1"
  local item="$2"
  shift 2

  case "$action" in
    install)
      read -q "choice? *** Would you like to install ${item}? (y/n)"
      y=$?
      echo
      return "$y"

      ;;
    *)
      return 1
      ;;
  esac

  return 0
}
