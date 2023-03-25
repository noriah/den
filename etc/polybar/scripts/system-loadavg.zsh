#!/usr/bin/env zsh

awk '{ printf("%s/%s/%s / %s / %s", $1, $2, $3, $4, $5) }' < /proc/loadavg
