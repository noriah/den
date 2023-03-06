#!/usr/bin/env zsh

item="$1"
shift
format="$@"

[ -z "$format" ] && format="%s"

query_smi() {
  nvidia-smi --query-$1=$2 --format=csv,noheader,nounits
}

getIcon() {
  pct="$1"

  if ((pct<=25)); then
    color="#83cd64"
    icon="󰡳"
  elif ((25<pct && pct<=50)); then
    color="#d9da6b"
    icon="󰡵"
  elif ((50<pct && pct<=75)); then
    color="#e4a471"
    icon="󰊚"
  else
    color="#ec7875"
    icon="󰡴"
  fi

  printf '%%{F%s}%%{T3}%s%%{T-}%%{F-}' "$color" "$icon"
}


case "$item" in
  mempct)
    printf "$format" $(query_smi gpu memory.used,memory.total | awk -F, '{ printf "%2d\n",($1/$2)*100 }')
    ;;
  apps)
    printf "$format" $(nvidia-smi -q -d PIDS | awk '/Process ID/ { count++ } END { print count }')
    ;;
  all)
    util="$($0 utilization.gpu %2s)"
    printf '%s %-3s%% / %-3s%% / %-5sMB / %-3s#' \
      "$(getIcon $util)" \
      $util \
      $($0 mempct %2s) \
      $($0 memory.used %3s) \
      $($0 apps %2s)
      ;;
  *)
    printf "$format" $(query_smi gpu $item | awk '{ print $1 }')
    ;;
esac

