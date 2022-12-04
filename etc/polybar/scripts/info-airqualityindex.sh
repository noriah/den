#!/bin/sh

# https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/info-airqualityindex

. `dirname $0`/config/info-airqualityindex.sh

API="https://api.waqi.info/feed"

ICON="" # leaf

if [ -n "$CITY" ]; then
  aqi=$(curl -sf "$API/$CITY/?token=$TOKEN")
else
  echo "NO CITY"
fi

if [ -n "$aqi" ]; then
  if [ "$(echo "$aqi" | jq -r '.status')" = "ok" ]; then
    aqi=$(echo "$aqi" | jq '.data.aqi')

    if [ "$aqi" -lt 50 ]; then
      echo "%{F#009966}$ICON%{F-} $aqi"
    elif [ "$aqi" -lt 100 ]; then
      echo "%{F#ffde33}$ICON%{F-} $aqi"
    elif [ "$aqi" -lt 150 ]; then
      echo "%{F#ff9933}$ICON%{F-} $aqi"
    elif [ "$aqi" -lt 200 ]; then
      echo "%{F#cc0033}$ICON%{F-} $aqi"
    elif [ "$aqi" -lt 300 ]; then
      echo "%{F#660099}$ICON%{F-} $aqi"
    else
      echo "%{F#7e0023}$ICON%{F-} $aqi"
    fi
  else
    echo "$aqi" | jq -r '.data'
  fi
fi
