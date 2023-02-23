#!/usr/bin/env zsh

# https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/system-nvidia-smi

query_smi() {
  nvidia-smi --query-$1=$2 --format=csv,noheader,nounits
}

case "$1" in
  mempct)
    query_smi gpu memory.used,memory.total | awk -F, '{ printf "%2d\n",($1/$2)*100 }'
    ;;
  apps)
    nvidia-smi -q -d PIDS | awk '/Process ID/ { count++ } END { print count }'
    ;;
  *)
    query_smi gpu $1 | awk '{ print $1 }'
    ;;
esac
