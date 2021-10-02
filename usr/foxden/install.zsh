#!/usr/bin/env zsh

FOX_DEN="$(dirname "$(dirname "${0:h:A}")")"

DEN_OK="$FOX_DEN/.ok"

[[ -f "$DEN_OK" ]] && echo "den is already installed." && exit 0

function checkExists() {
  if [[ -e "$2/$1" ]]; then
    echo "'$1' already exists in '$2'. can't continue."
    echo "no changes made."
    exit 1
  fi
}

checkExists 'etc' "$HOME"
checkExists 'usr' "$HOME"
checkExists 'var' "$HOME"
checkExists 'var' "$FOX_DEN"

echo "all good. continuing."

function linkDen() {
  echo "creating symlink '$HOME/$1' -> '$FOX_DEN/$1'"
  ln -s "$FOX_DEN/$1" "$HOME/$1"
}

function sourceDen() {
  if [ -e "$HOME/.$1" ]; then
    echo "replacing '$HOME/$1' (backuped up to '$HOME/.$1.old')"
    mv "$HOME/.$1" "$HOME/.$1.old"
  fi

  echo "sourcing '$HOME/.$1' from '$FOX_DEN/etc/zsh/$1'"
  echo ". \"$FOX_DEN/etc/zsh/$1\"" > "$HOME/.$1"
}

[ ! -d "$HOME/opt" ] && mkdir "$HOME/opt"

linkDen 'etc'
linkDen 'usr'

mkdir "$FOX_DEN/var"
mkdir "$FOX_DEN/var/cache"
mkdir "$FOX_DEN/var/history"

linkDen 'var'

sourceDen 'zshenv'
sourceDen 'zshrc'

touch "$DEN_OK"

echo "den installation complete. enjoy!"
