if den::is::linux; then
  den::install::link '.config/i3' 'etc/i3'
else
  echo "noop"
fi
