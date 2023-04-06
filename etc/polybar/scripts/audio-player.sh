#!/bin/sh

/home/nor/workspace/local/zscroll/zscroll --length 30 \
  --delay 0.1 \
  --scroll-padding " <!> " \
  --match-command "`dirname $0`/get_player_status.zsh --status" \
  --match-text "Playing" "--scroll 1" \
  --match-text "Paused" "--scroll 0" \
  --update-check true \
  --update-before-text true \
  --update-after-text true \
  --before-text "`dirname $0`/get_player_icon.zsh" \
  --after-text "`dirname $0`/get_player_timecode.zsh" \
  "`dirname $0`/get_player_status.zsh" &

wait