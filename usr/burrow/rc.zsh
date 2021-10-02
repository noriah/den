env_default 'BURROW_OPT' "$HOME_OPT/burrow"

if [ -z "$_FOX_DEN_BURROW_LIST" ]; then
  typeset -ga _FOX_DEN_BURROW_LIST
fi

. "${0:h:A}/fn.zsh"
