if isMac; then
  echo "add .hushlogin to $HOME"
  touch "$HOME/.hushlogin"
else
  echo "noop"
fi
