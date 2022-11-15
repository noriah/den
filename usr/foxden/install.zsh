#!/usr/bin/env zsh

# set common variables
FOX_DEN_SETUP="${0:h:A}/setup"
FOX_DEN="$(dirname "$(dirname "${0:h:A}")")"

INSTALL_OK="$FOX_DEN/.ok"

[ -f "$INSTALL_OK" ] && echo "den is already installed." && exit 0

. "${0:h:A}/fn.zsh"
. "$FOX_DEN_SETUP/fn.zsh"

den::source usr/burrow/rc.zsh

den::install::checkExists 'etc' "$HOME"
den::install::checkExists 'usr' "$HOME"
den::install::checkExists 'var' "$HOME"
#den::install::checkExists 'var' "$FOX_DEN"

echo "clean environment. can continue."

[ ! -d "$HOME/opt" ] && mkdir "$HOME/opt"

# link etc
den::install::link 'etc'

# link usr
den::install::link 'usr'

echo "making dir '$HOME/opt' (if it does not already exist)."
mkdir "$HOME/opt"

# make var dir and subdirs
mkdir "$HOME_VAR"
mkdir "$HOME_VAR/cache"
mkdir "$HOME_VAR/history"

# link var
#den::install::link 'var'

# source environment
den::install::source 'zshenv'

# source rc
den::install::source 'zshrc'

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
