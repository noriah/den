if den::is::linux; then
  den::install::ensureDir '.config'
  den::install::checkBackupHome '.config/polybar'
  den::install::link '.config/polybar' 'etc/polybar'
else
  echo "noop"
fi
