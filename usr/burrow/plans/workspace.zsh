den::env::default 'WORKSPACE_DIR' "$HOME/workspace"
den::env::default 'WORKSPACE_PUBLIC_KEY' 'public'
den::env::default 'WORKSPACE_LOCAL_KEY' 'local'
den::env::default 'WORKSPACE_NOTES_KEY' 'notes'
den::env::default 'WORKSPACE_VAULT_KEY' 'vault'

alias pubsp='cd $WORKSPACE_DIR/$WORKSPACE_PUBLIC_KEY'
alias localsp='cd $WORKSPACE_DIR/$WORKSPACE_LOCAL_KEY'
alias notessp='cd $WORKSPACE_DIR/$WORKSPACE_NOTES_KEY'
alias vaultsp='cd $WORKSPACE_DIR/$WORKSPACE_VAULT_KEY'

if [ ! -e "$WORKSPACE_DIR/tmp" ]; then
  local _wkspTmpDir="/tmp/$DEN_USER-workspace-tmp"

  if [ ! -d "$_wkspTmpDir" ]; then
    mkdir -p "$_wkspTmpDir"
    chmod 700 "$_wkspTmpDir"
  fi

  ln -s $_wkspTmpDir "$WORKSPACE_DIR/tmp"

  unset _wkspTmpDir
fi
