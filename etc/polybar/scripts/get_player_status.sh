#!/bin/sh

BAR_NAME=${BAR_NAME:-main-top}

PLAYER=${PLAYER:-spotify}
PLAYER_NAME=${PLAYER_NAME:-$(perl -wp -e '$_ = ucfirst' < <(echo $PLAYER))}

FORMAT="{{ title }} - {{ artist }}"

print_metadata() {
  playerctl metadata \
    --player "$PLAYER" \
    --format "$FORMAT"
}

update_bar_icon() {
  local _bar_pid=$(pgrep -a "polybar" | grep "$BAR_NAME" | cut -d" " -f1)
  polybar-msg -p "$_bar_pid" hook ${PLAYER}-controls $1 1>/dev/null 2>&1
}

STATUS=$(playerctl status --player "$PLAYER" 2>/dev/null)

if [ $? -ne 0 ]; then
  STATUS="No players found"
fi

if [ "$1" = "--status" ]; then
  echo "$STATUS"
else
  case "$STATUS" in
    "No players found") echo "$PLAYER_NAME is not running";;
    Stopped) echo "No music playing" ;;
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
