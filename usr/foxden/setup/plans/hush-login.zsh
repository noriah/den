if den::is::mac; then
  echo "add .hushlogin to $HOME"
  touch "$HOME/.hushlogin"
else
  echo "noop"
fi
