den::env::default 'HISTSPACE_DIR' "${HISTORY}/histspace"

histspace::load() {
  [ -d "$HISTSPACE_DIR" ] || mkdir -p "$HISTSPACE_DIR"

  local _spaceId="$1"
  local _histspaceFile="${HISTSPACE_DIR}/${_spaceId}"

  history -p

  if [ -f "$_histspaceFile" ]; then
    fc -R "$_histspaceFile"
    printf "\nloaded shell history for '%s'\n" "$_spaceId"
  else
    printf "\nstarted new shell history for '%s'\n" "$_spaceId"
  fi

  export HISTFILE="$_histspaceFile"

  unset _spaceId
  unset _histspaceFile
}

histspace() {
  histspace::load "$@"
}
