#!/usr/bin/env zsh

START_DIR="${0:a:h}"
CSS="$START_DIR/css"

if [ ! -d "$CSS" ]; then
  mkdir "$START_DIR/css"
fi

sass "$START_DIR/sass/style.scss" "$CSS/style.css"
