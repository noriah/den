#!/usr/bin/env zsh

BAR_NAME=${BAR_NAME:-main-top}

PLAYER=${PLAYER:-spotify}

FORMAT="{{ position }} {{ mpris:length }}"

METADATA_CMD=(playerctl metadata --player "$PLAYER" --format "$FORMAT")

print_timecode() {
  $METADATA_CMD | TZ=UTC0 awk '
    {p=$1/1000000; t=$2/1000000}
    END {
      f="%M:%S"
      b = ""
      a = ""
      if (t > 3600) {
        f="%T"
      } else {
        b = "  "
        a = "    "
      }
      print "|" b strftime(f, p) "/" strftime(f, t) a
    }
  '
}

STATUS=$(playerctl status --player "$PLAYER" 2>/dev/null)

if [ $? -ne 0 ]; then
  STATUS="No players found"
fi

if [ "$1" = "--status" ]; then
  echo "$STATUS"
else
  case "$STATUS" in
    Stopped|"No players found")
      echo "--:--/--:--"
      ;;
    *)
      print_timecode
      ;;
  esac
fi
