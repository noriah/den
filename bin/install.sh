#!/usr/bin/env zsh

if [ $# -eq 0 ]; then
  exit 1
fi

file=$(basename "$1")

if [ ! -f "$1" ]; then
  exit 1
fi

if [ -f "/usr/local/bin/$file" ]; then
  read -q "REPLY?overwrite? (y/n)"
  echo
  if [ $REPLY != y ]; then
    exit 1
  fi
fi

echo "copying $1 to /usr/local/bin"

cp -f "$1" "/usr/local/bin/$file"
