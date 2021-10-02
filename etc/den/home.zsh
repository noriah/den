#!/usr/bin/env zsh

##############
#
# noriah's den
#
# please wipe your feet on the way in.
#
######################################

export DEN_USER='noriah'

# load our den manager
denSource usr/burrow/rc.zsh

# we have languages but handle them separate.
# just add entries so other plugins know.
# sharing is caring.
burrow golang
burrow rust
burrow node

burrow neofetch
# burrow taskwarrior
burrow workspace

denConf host/$(hostname -s).zsh

# jump around?
burrow z github/rupa/z z.sh

# auto suggestions are always wrong
# NO. BAD. DO NOT USE. DOES NOT SCRUB SECRETS.
#burrow suggestions \
#	github/zsh-users/zsh-autosuggestions \
#	zsh-autosuggestions.zsh

# it is nice to look nice. but it also helps
# us see things easier.
burrow highlight \
	github/zdharma/fast-syntax-highlighting \
	fast-syntax-highlighting.plugin.zsh

# for that one problem
burrow autoenv \
	github/Tarrasch/zsh-autoenv \
	autoenv.zsh

# power the levels. 10k of them.
burrow p10k \
	github/romkatv/powerlevel10k \
	powerlevel10k.zsh-theme

