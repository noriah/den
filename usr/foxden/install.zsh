#!/usr/bin/env zsh

# set common variables
FOX_DEN="${0:h:A}"
FOX_DEN_SETUP="$FOX_DEN/setup"
DEN="$(dirname "$(dirname "${0:h:A}")")"

INSTALL_OK="$DEN/.ok"

[ -f "$INSTALL_OK" ] && echo "den is already installed." && exit 0

. "$FOX_DEN/base/functions.zsh"
. "$FOX_DEN_SETUP/fn.zsh"

den::source usr/burrow/rc.zsh

den::install::checkExists 'etc' "$HOME"
den::install::checkExists 'usr' "$HOME"
den::install::checkExists 'var' "$HOME"

echo "clean environment. can continue."

echo "making dir '$HOME/opt' (if it does not already exist)."
[ ! -d "$HOME/opt" ] && mkdir "$HOME/opt"

# link etc
den::install::link 'etc'

# link usr
den::install::link 'usr'

HOME_VAR="$HOME/var"

# make var dir and subdirs
mkdir "$HOME_VAR"
mkdir "$HOME_VAR/cache"
mkdir "$HOME_VAR/history"

if den::is::linux; then
  mkdir -p "$HOME/.local"
  den::install::checkBackupHome '.local/share'
  ln -s "$HOME_VAR" "$HOME/.local/share"
fi

den::install::checkBackupHome '.cache'
ln -s "$HOME_VAR/cache" "$HOME/.cache"

# source environment
den::install::source 'zshenv'

# source rc
den::install::source 'zshrc'

# load paths variables
den::source 'etc/zsh/zshenv'

echo "running install scripts from '$FOX_DEN_SETUP/plans'."

for i in "$FOX_DEN_SETUP/plans/"*.zsh; do
  echo "*** running script '$i'. ***"
  . "$i"
done

echo "done with scripts."

# set the flag
touch "$INSTALL_OK"

echo "den installation complete. enjoy!"

# all done
