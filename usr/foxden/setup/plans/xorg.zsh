if den::is::linux; then
  den::install::checkBackupHome '.Xresources'
  den::install::link '.Xresources' 'etc/xorg/Xresources'
else
  echo "noop"
fi
