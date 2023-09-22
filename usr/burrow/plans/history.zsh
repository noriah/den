HISTORY_SPACES_ROOT="${HISTORY_ROOT}/spaces"
HISTORY_DEFAULT="${HISTORY}"

history::load_default () {
  den::export::verbose HISTORY "$HISTORY_DEFAULT"
  export HISTFILE="$HISTORY/zsh"

  [[ -d "$HISTORY" ]] || mkdir -p "$HISTORY"

  if [ -f "$HISTFILE" ]; then
    fc -R "$HISTFILE"
    printf "loaded default shell history\n"
  fi
}

history::load_space () {
  local _spaceType="${1}"
  local _spaceId="${2}"
  if [ $# -gt 2 ]; then
    local _spaceName="${3}"
  else
    local _spaceName="$_spaceId"
  fi

  local _spaceDir="$(echo "$_spaceType" | tr '\-\/\\\ #' '_' | tr '[:upper:]' '[:lower:]')"
  _spaceId="$(echo "$_spaceId" | tr '\-\/\\\ #' '_' | tr '[:upper:]' '[:lower:]')"

  printf "\n"

  den::export::verbose HISTORY "$HISTORY_SPACES_ROOT/$_spaceDir/$_spaceId"

  [[ -d "$HISTORY" ]] || mkdir -p "$HISTORY"

  local _histfilePath="$HISTORY/zsh"

  printf "\n"

  if [ -f "$_histfilePath" ]; then
    fc -R "$_histfilePath"
    printf "loaded shell history for $_spaceType: %s\n" "$_spaceName"
  else
    printf "no shell history for $_spaceType: %s\n" "$_spaceName"
  fi

  export HISTFILE="$_histfilePath"

  unset _spaceType
  unset _spaceId
  unset _spaceName
  unset _spaceDir
  unset _histfilePath

  return 0
}
