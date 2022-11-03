env_default 'BURROW_OPT' "$HOME_OPT/burrow"

if [ -z "$_FOX_DEN_BURROW_LIST" ]; then
  typeset -ga _FOX_DEN_BURROW_LIST
  typeset -gA _FOX_DEN_BURROW_REPO_LIST
fi

den::source  usr/burrow/fn.zsh
