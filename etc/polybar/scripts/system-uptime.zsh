#!/usr/bin/env zsh

uptime | awk '
  /up/ { d=$3; t=$5; sub(",", "", t); sub (":", "h ", t) }
  END { print d "d " t "m" }'
