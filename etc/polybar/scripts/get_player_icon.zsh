#!/usr/bin/env zsh

. `dirname $0`/get_player_common.zsh

printLine() {
  printf '%%{T4}%%{F#%s}%s%%{F-}%%{T7}' "$1" "$2"
}

case "$(getPlayer $(getPlayerRaw))" in
  spotify)
    printLine 1db954 "阮 "
    ;;
  vlc)
    printLine ff9800 "嗢 "
    ;;
  *)
    printLine 3399ff " "
    ;;
esac
