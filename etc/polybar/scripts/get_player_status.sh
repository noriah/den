#!/bin/sh

PLAYER_LOWER=$(echo ${PLAYER:=Spotify} | tr '[:upper:]' '[:lower:]')
FORMAT="{{ title }} - {{ artist }}"

STATUS=$(playerctl status --player "$PLAYER_LOWER" 2>/dev/null)

if [ $? -ne 0 ]; then
  STATUS="No players found"
fi

if [ "$1" = "--status" ]; then
  echo "$STATUS"
else
  case "$STATUS" in
    Stopped) echo "No music playing" ;;
    "No players found") echo "$PLAYER is not running";;
    *)
      playerctl metadata \
      --player "$PLAYER_LOWER" \
      --format "$FORMAT"
      ;;
  esac
fi
