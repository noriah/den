if isLinux;
  # remove unused shells

  checkRmHome '.bashrc'
  checkRmHome '.bash_logout'
  checkRmHome '.kshrc'

else
  echo "noop"
fi
