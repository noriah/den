checkExists() {
  if [ -e "$2/$1" ]; then
    echo "'$1' already exists in '$2'. can not continue."
    echo "no changes made."
    exit 1
  fi
}

checkBackupHome() {
  if [ -e "$HOME/$1" ]; then
    echo "replacing '$HOME/$1' (backup in '$HOME/$1.old')"
    mv "$HOME/$1" "$HOME/$1.old"
  fi
}

ensureDir() {
  if [ ! -d "$HOME/$1" ]; then
    echo "creating directory(s) '$HOME/$1'."
    mkdir -p "$HOME/$1"
  fi
}

linkDen() {
  FILE="$1"
  if [ $# -eq 2 ]; then
    shift
  fi

  echo "creating symlink '$HOME/$FILE' -> '$FOX_DEN/$1'"
  ln -s "$FOX_DEN/$1" "$HOME/$FILE"
}

sourceDen() {
  checkBackupHome ".$1"

  echo "sourcing '$HOME/.$1' from '$FOX_DEN/etc/zsh/$1'"
  echo ". \"$FOX_DEN/etc/zsh/$1\"" > "$HOME/.$1"
}
