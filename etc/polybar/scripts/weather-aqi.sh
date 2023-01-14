#!/bin/sh

# https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/info-airqualityindex

. `dirname $0`/config/weather-aqi.sh

API="https://api.waqi.info/feed"

ICON="" # leaf

echo_value() {
  echo "%{F$1}$ICON%{F-} $2"
}

if [ -n "$CITY" ]; then
  aqi=$(curl -sf "$API/$CITY/?token=$TOKEN")

  if [ "$(echo "$aqi" | jq -r '.status')" = "ok" ]; then
    aqi=$(echo "$aqi" | jq '.data.aqi')

    if [ "$aqi" -le 50 ]; then
      # good
      echo_value 689f38 $aqi
    elif [ "$aqi" -le 100 ]; then
      # moderate
      echo_value fbc02d $aqi
    elif [ "$aqi" -le 150 ]; then
      # unhealthy (for sensitive groups)
      echo_value f57c00 $aqi
    elif [ "$aqi" -le 200 ]; then
      # unhealthy
      echo_value c53929 $aqi
    elif [ "$aqi" -le 300 ]; then
      # very unhealthy
      echo_value ad1457 $aqi
    else
      # hazardous
      echo_value 880e50 $aqi
    fi

  else
    echo "$aqi" | jq -r '.data'
  fi

else
  echo_value ff0000 "NO CITY"
fi
