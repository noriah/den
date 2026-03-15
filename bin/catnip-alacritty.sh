#!/usr/bin/env bash

WINDOW_NAME="Catnip Visualizer"
DEVICE_NAME="vis_source"
#DEVICE_NAME="Google Chrome"

args=(
  -r 44100 -n 735
  -i
  -dt 1
  -bt 1 -bw 7
  -sm 3 -sas 4 -sf 40
)

wmctrl -r "$WINDOW_NAME" -b add,above,sticky

catnip -d "$DEVICE_NAME" "${args[@]}"
#catnip -d "$DEVICE_NAME" -r 122880 -n 2048 -i -dt 1 -bt 0 -bw 7 -sm 3 -bw 5 -sas 4 -sf 40

# catnip -d spotify -r 122880 -n 2048 -bt 1 -bs 1 -bw 2 -i -dt 8 -sas 6 -sf 55
