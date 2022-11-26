#!/usr/bin/env sh

ffmpeg -i "$1" -c:v h264 -strict -2 -movflags faststart -b:v 1.0M "$2"
