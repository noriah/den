#!/usr/bin/env zsh

item="$1"

query_smi() {
  amd-smi metric --csv $1
}

getIcon() {
  pct="$1"

  if ((pct<=25)); then
    color="#83cd64"
    icon="󰡳" # low gauge
  elif ((25<pct && pct<=50)); then
    color="#d9da6b"
    icon="󰡵" # lower mid gauge
  elif ((50<pct && pct<=75)); then
    color="#e4a471"
    icon="󰊚" # upper mid gauge
  else
    color="#ec7875"
    icon="󰡴" # high gauge
  fi

  printf '%%{F%s}%%{T3}%s%%{T-}%%{F-}' "$color" "$icon"
}


case "$item" in
  mempct)
    query_smi -m | awk -F, 'NR==3 { printf "%2d%\n",($3/$2)*100 }'
    ;;
  memmb)
    query_smi -m | awk -F, 'NR==3 { printf "%-5sMB\n",$3 }'
    ;;
  util)
    util=$(query_smi -u | awk -F, 'NR==3 { print $2 }')
    printf '%s %-3s%%\n' \
      "$(getIcon $util)" \
      $util
      ;;
  all)
    printf '%s / %s / %s\n' \
      "$($0 util)" \
      "$($0 mempct)" \
      "$($0 memmb)"
      ;;
  *)
    echo "nope"
    ;;
esac

