if den::is::linux; then
  den::install::ensureDir '.config'
  den::install::checkBackupHome '.config/systemd'
  den::install::link '.config/systemd' 'usr/systemd'
else
  echo "noop"
fi
