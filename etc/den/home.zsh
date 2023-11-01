#!/usr/bin/env zsh

##############
#
# noriah's den
#
# please wipe your feet on the way in.
#
######################################

export DEN_USER='noriah'
export DEN_HOST=$(hostname -f | cut -d. -f1)

# load our den manager
den::source usr/burrow/rc.zsh

den::conf base.zsh

# load the host-specific configuration
den::conf host/${DEN_HOST}.zsh

den::path::add "$HOME/rbin"

# we have languages but handle them separate.
# just add entries so other plugins know.
# sharing is caring.
burrow plugin golang
burrow plugin rust
burrow plugin node
burrow plugin python
burrow plugin julia

burrow plugin neofetch
# burrow plugin taskwarrior

# workspace directories
burrow plugin workspace

burrow plugin tmpdirs

# multiple history
burrow plugin histspace

# common dev things
burrow plugin dev

# jump around?
burrow plugin z github/rupa/z z.sh

# auto suggestions are always wrong
# NO. BAD. DO NOT USE. DOES NOT SCRUB SECRETS.
# burrow plugin \
#   suggestions \
#   github/zsh-users/zsh-autosuggestions \
#   zsh-autosuggestions.zsh

# for that one problem
burrow plugin \
  autoenv \
  github/Tarrasch/zsh-autoenv \
  autoenv.zsh

# fzf
burrow plugin fzf

# fzf-tab
burrow plugin \
  fzf-tab \
  github/Aloxaf/fzf-tab \
  fzf-tab.plugin.zsh

# it is nice to look nice. but it also helps
# us see things easier.
burrow plugin \
  highlight \
  github/zdharma-continuum/fast-syntax-highlighting \
  fast-syntax-highlighting.plugin.zsh

# Make sure we are not running in a linux console. The font does not work.
if [ "$TERM" != "linux" ]; then
# power the levels. 10k of them.
  burrow plugin p10k \
    github/romkatv/powerlevel10k \
    powerlevel10k.zsh-theme
fi

