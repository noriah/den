#!/usr/bin/env zsh

uptime | awk '
  /days/ { d=$3; h=substr($5, 1, 2); m=substr($5, 4, 2) }
  /[0-9]:[0-5][0-9],/ { d="00"; h="0"substr($3, 1, 1); m=substr($3, 3, 2) }
  /[1-2][0-9]:[0-5][0-9],/ { d="00"; h=substr($3, 1, 2); m=substr($3, 3, 2) }
  /min/ { d="00"; h="00"; m=$3 }
  END { print d "d " h "h " m "m" }'
