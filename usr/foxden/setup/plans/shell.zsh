if den::is::linux; then
  # remove unused shells
  den::install::checkRmHome '.bashrc'
  den::install::checkRmHome '.bash_logout'
  den::install::checkRmHome '.kshrc'
else
  echo "noop"
fi
