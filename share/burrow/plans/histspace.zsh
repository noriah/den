histspace () {
  HISTSPACE_NAME="$@" zsh
}

burrow::plugin::fail

if burrow::check 'history' && [[ -v HISTSPACE_NAME ]]; then

  typeset -g HISTSPACE_SESSION_NAME="$HISTSPACE_NAME"

  # tell others that we are in a histspace session
  burrow::plugin::pass

  history::load_space 'hist' "$HISTSPACE_NAME"

  printf "\n"
fi
