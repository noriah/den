if isLinux; then
  checkBackupHome '.selected_editor'
  echo 'SELECTED_EDITOR="/usr/bin/vim.gtk3"' > $HOME/.selected_editor
else
  echo "noop"
fi
