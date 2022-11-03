if den::is::linux; then
  den::install::checkBackupHome '.selected_editor'
  echo 'SELECTED_EDITOR="/usr/bin/vim.gtk3"' > $HOME/.selected_editor
else
  echo "noop"
fi
