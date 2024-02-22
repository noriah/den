local _homeTmpDir="/tmp/noriah-home-tmp"
local _runUserDir="/run/user/$(id -u)"


if [ -d "$_runUserDir" ]; then
  _homeTmpDir="$_runUserDir"
fi

if [ ! -d "$_homeTmpDir" ]; then
  mkdir -p "$_homeTmpDir"
  chmod 700 "$_homeTmpDir"
fi

if [ ! -e "$HOME/tmp" ]; then
  ln -s $_homeTmpDir "$HOME/tmp"
fi

unset _homeTmpDir
