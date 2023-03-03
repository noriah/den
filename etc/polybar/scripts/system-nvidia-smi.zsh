#!/usr/bin/env zsh

# https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/system-nvidia-smi

item="$1"
shift
format="$@"

[ -z "$format" ] && format="%s"

query_smi() {
  nvidia-smi --query-$1=$2 --format=csv,noheader,nounits
}

case "$item" in
  mempct)
    printf "$format" $(query_smi gpu memory.used,memory.total | awk -F, '{ printf "%2d\n",($1/$2)*100 }')
    ;;
  apps)
    printf "$format" $(nvidia-smi -q -d PIDS | awk '/Process ID/ { count++ } END { print count }')
    ;;
  all)
    printf '%-4s / %-4s / %-7s / %-3s' \
      $($0 utilization.gpu %s%%) \
      $($0 mempct %s%%) \
      $($0 memory.used %sMB) \
      $($0 apps '#%s')
      ;;
  *)
    printf "$format" $(query_smi gpu $item | awk '{ print $1 }')
    ;;
esac
