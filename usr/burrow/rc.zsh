den::env::default 'BURROW_OPT' "$HOME_OPT/burrow"

if [ -z "$_DEN_BURROW_LIST" ]; then
  typeset -ga _DEN_BURROW_LIST
  typeset -gA _DEN_BURROW_REPO_LIST
fi

den::source  usr/burrow/fn.zsh
