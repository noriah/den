if [ ! -e "$HOME/tmp" ]; then
  local _homeTmpDir="/tmp/$DEN_USER-home-tmp"
  local _runUserDir="/run/user/$(id -u)"

  if [ -d "$_runUserDir" ]; then
    _homeTmpDir="$_runUserDir"
  fi

  if [ ! -d "$_homeTmpDir" ]; then
    mkdir -p "$_homeTmpDir"
    chmod 700 "$_homeTmpDir"
  fi

  ln -s $_homeTmpDir "$HOME/tmp"

  unset _homeTmpDir

fi
