if den::is::linux; then
  den::install::checkBackupHome '.config/wezterm'
  den::install::link '.config/wezterm' 'etc/wezterm'
else
  echo "noop"
fi
