#!/usr/bin/env zsh

. `dirname $0`/config/info-trimet.zsh

MAX_ICON="󰔭" # tram
BUS_ICON="󰃧" # bus
API="https://developer.trimet.org/ws/v2/arrivals"

current_time="$(date +%s)000"

get_arrival_data_for_stops() {
  stops="$1"
  ARRIVAL_DATA=$(curl -sf "$API?appID=$APP_ID&locIDs=$stops" \
    | jq '.resultSet.arrival | map(select(.status == "estimated"))')
}

get_closest_arrival() {
  stop="$1"
  sign="$2"

  stop_data=$(echo $ARRIVAL_DATA | jq 'map(select(.locid == '$stop'))')

  if [ ! -z "$sign" ]; then
    stop_data=$(echo $stop_data | jq 'map(select(.shortSign | match("'$sign'")))')
  fi

  NEAREST_ARRIVAL=$(echo $stop_data | jq 'min_by(.estimated)')
}

get_line_color() {
  echo -n $(echo $NEAREST_ARRIVAL | jq -r '.routeColor')
}

get_arrival_time() {
  estimated=$(echo $NEAREST_ARRIVAL | jq -r '.estimated')
  diff=$(( ( ( estimated - current_time ) / 1000 ) / 60 ))
  echo -n $diff
}

get_line_icon() {
  routeSubType=$(echo $NEAREST_ARRIVAL | jq -r '.routeSubType')

  case "$routeSubType" in
    "Light Rail")
      echo $MAX_ICON
      ;;
    Bus)
      echo $BUS_ICON
      ;;
  esac
}

print_value() {
  printf '%%{F%s}%%{T3}%s%%{T-}%%{F-} %d min' "$1" $3 "$2"
}

print_stop() {
  get_closest_arrival "$1" "$2"
  print_value $(get_line_color) $(get_arrival_time) $(get_line_icon)
}

get_arrival_data_for_stops 7640,7646,7777,8334,8383

echo -n "N "
print_stop 7777 # Pioneer Square North
echo -n " / S "
print_stop 7646 Orange # Pioneer Place South
echo -n " / E "
print_stop 8334 # Pioneer Square East
echo -n " / W "
print_stop 8383 # Pioneer Square West
echo -n " | L19S "
print_stop 7640 "19 To" # SW 5th & Taylor #19
echo -n " / L17S "
print_stop 7640 "17 To" # SW 5th & Taylor #17
