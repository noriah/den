#!/bin/sh

zscroll --length 30 \
  --delay 0.13 \
  --scroll-padding "  " \
  --match-command "`dirname $0`/get_player_status.sh --status" \
  --match-text "Playing" "--scroll 1" \
  --match-text "Paused" "--scroll 0" \
  --update-check true \
  "`dirname $0`/get_player_status.sh" &

wait
