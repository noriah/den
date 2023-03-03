#!/usr/bin/env zsh

# https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/openweathermap-simple

. `dirname $0`/config/weather-forecast.zsh

API="https://api.openweathermap.org/data/2.5"

get_icon() {
  case $1 in
    # Icons for nerd font
    01d) icon="";; # day-sunny
    01n) icon="";; # night-clear
    02d) icon="";; # day-cloudy
    02n) icon="";; # night-alt-cloudy
    03*) icon="";; # cloud
    04d) icon="";; # day-cloudy
    04n) icon="";; # night-cloudy
    09d) icon="";; # rain-wind
    09n) icon="";; # rain-wind
    10d) icon="";; # day-rain
    10n) icon="";; # night-rain
    11d) icon="";; # day-lightning
    11n) icon="";; # night-alt-lightning
    13d) icon="";; # day-snow
    13n) icon="";; # night-alt-snow
    50d) icon="";; # day-fog
    50n) icon="";; # night-fog
    *) icon="";; # day-sunny
  esac

  echo "%{T3}$icon%{T-}"
}

echo_value() {
  # valC=$(printf '%-4s\n' "$2$SYMBOL")
  # valF=$(printf '%-4s\n' "$3$SYMBOL")
  printf '%s  %-3s(%s)' $(get_icon "$1") "$2$SYMBOL" "$3$SYMBOL"
}

if [ -n "$CITY" ]; then
  if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
    CITY_PARAM="id=$CITY"
  else
    CITY_PARAM="q=$CITY"
  fi

  weather=$(curl -sf "$API/weather?appid=$TOKEN&$CITY_PARAM&units=$UNITS")

  weather_imp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
  weather_met=$(printf %.0f $(echo "scale=3;($weather_imp-32)*(5/9)" | bc))
  weather_icon=$(echo "$weather" | jq -r ".weather[0].icon")

  echo_value $weather_icon $weather_met $weather_imp
else
  echo "NO CITY"
fi

