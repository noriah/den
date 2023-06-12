#!/usr/bin/env zsh

. `dirname $0`/get_player_common.zsh

printLine() {
  printf '%%{T4}%%{F#%s}%s%%{F-}%%{T7}' "$1" "$2"
}

getPlayer $PLAYER

case "$PLAYER" in
  spotify)
    printLine 1db954 "󰓇 " # spotify
    ;;
  vlc)
    printLine ff9800 "󰕼 " # vlc
    ;;
  *)
    printLine 3399ff "󰎈 " # music note
    ;;
esac
