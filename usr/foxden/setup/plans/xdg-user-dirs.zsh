if den::is::linux; then
  den::install::ensureDir '.config'
  echo "disable xdg-user-dirs"

  echo 'enabled=False' > "$HOME/.config/user-dirs.conf"

  local NEW_DIR='xdg-dirs-backup'
  echo "move xdg dirs to '$HOME/$NEW_DIR'"

  den::install::ensureDir "$NEW_DIR"

  for i in Documents Downloads Music Pictures Public Templates Videos; do
    mv "$HOME/$i" "$HOME/$NEW_DIR/$i"
  done

  unset NEW_DIR
else
  echo "noop"
fi
