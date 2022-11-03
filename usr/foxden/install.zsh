#!/usr/bin/env zsh

# set common variables
FOX_DEN_SETUP="${0:h:A}/setup"
FOX_DEN="$(dirname "$(dirname "${0:h:A}")")"

INSTALL_OK="$FOX_DEN/.ok"

[ -f "$INSTALL_OK" ] && echo "den is already installed." && exit 0

. "${0:h:A}/fn.zsh"
. "$FOX_DEN_SETUP/fn.zsh"

den::source usr/burrow/rc.zsh

checkExists 'etc' "$HOME"
checkExists 'usr' "$HOME"
checkExists 'var' "$HOME"
checkExists 'var' "$FOX_DEN"

echo "all good. continuing."

[ ! -d "$HOME/opt" ] && mkdir "$HOME/opt"

# link etc
linkDen 'etc'

# link usr
linkDen 'usr'

echo "making dir '$HOME/opt' (if it does not already exist)."
mkdir "$HOME/opt"

# make var dir and subdirs
mkdir "$FOX_DEN/var"
mkdir "$FOX_DEN/var/cache"
mkdir "$FOX_DEN/var/history"

# link var
linkDen 'var'

# source environment
sourceDen 'zshenv'

# source rc
sourceDen 'zshrc'

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
