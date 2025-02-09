if den::is::linux; then
  den::install::ensureDir '.config'
  den::install::checkBackupHome '.config/systemd'
  den::install::link '.config/systemd' 'share/systemd'
else
  echo "noop"
fi
