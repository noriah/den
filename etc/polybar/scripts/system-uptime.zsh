#!/usr/bin/env zsh

uptime | awk '/up/ { d=$3; t=$5; sub(",", "", t) } END { print d "d " t "t" }'
