if isLinux; then
  linkDen '.config/i3' 'etc/i3'
else
  echo "noop"
fi
