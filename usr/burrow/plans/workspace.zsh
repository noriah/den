den::env::default 'WORKSPACE_DIR' "$HOME/workspace"
den::env::default 'WORKSPACE_PRO_KEY' 'public'
den::env::default 'WORKSPACE_LOCAL_KEY' 'local'
den::env::default 'WORKSPACE_NOTES_KEY' 'notes'

alias prosp='cd $WORKSPACE_DIR/$WORKSPACE_PRO_KEY'
alias localsp='cd $WORKSPACE_DIR/$WORKSPACE_LOCAL_KEY'
alias notessp='cd $WORKSPACE_DIR/$WORKSPACE_NOTES_KEY'
alias vaultsp='cd $WORKSPACE_DIR/vault'

local _wkspTmpDir="/tmp/noriah-workspace-tmp"

if [ ! -d "$_wkspTmpDir" ]; then
  mkdir -p "$_wkspTmpDir"
fi

if [ ! -e "$WORKSPACE_DIR/tmp" ]; then
  ln -s $_wkspTmpDir "$WORKSPACE_DIR/tmp"
fi

unset _wkspTmpDir
