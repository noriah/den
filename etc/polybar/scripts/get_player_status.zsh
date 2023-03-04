#!/usr/bin/env zsh

. `dirname $0`/get_player_common.zsh

PLAYER="$(getPlayer $PLAYER)"
BAR_NAME=${BAR_NAME:-main-top}

FORMAT="{{ title }} - {{ artist }}"

print_metadata() {
  playerctl metadata \
    --player "$PLAYER" \
    --format "$FORMAT"
}

update_bar_icon() {
  local _bar_pid=$(pgrep -a "polybar" | grep "$BAR_NAME" | cut -d" " -f1)
  polybar-msg -p "$_bar_pid" hook player-controls $1 1>/dev/null 2>&1
}

STATUS=$(playerctl status --player "$PLAYER" 2>/dev/null)

if [ $? -ne 0 ]; then
  STATUS="No players found"
fi

if [ "$1" = "--status" ]; then
  echo "$STATUS"
else
  case "$STATUS" in
    "No players found") echo "No player is running";;
    Stopped) echo "Nothing is playing" ;;
    Paused)
      update_bar_icon 1
      print_metadata
      ;;
    *)
      update_bar_icon 2
      print_metadata
      ;;
  esac
fi
