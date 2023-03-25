#!/usr/bin/env zsh

uptime | awk '
  /days?,  [0-9]:/ { d=$3; h=substr($5, 1, 1); m=substr($5, 3, 2); end }
  /days?, [1-2][0-9]:/ { d=$3; h=substr($5, 1, 2); m=substr($5, 4, 2); end }
  /days?, [0-9]+ min,/ { d=$3; h=0; m=$5; end }
  /up [0-9]+ min,/ { d=0; h=0; m=$3; end }
  /up [0-9]:/ { d=0; h=substr($3, 1, 1); m=substr($3, 3, 2); end }
  /up [1-2][0-9]:/ { d=0; h=substr($3, 1, 2); m=substr($3, 4, 2); end }
  END { printf("%02dd %02dh %02dm", d, h, m) }'
