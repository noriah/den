den::env::default 'WORKSPACE_DIR' "$HOME/workspace"
den::env::default 'WORKSPACE_PRO_KEY' "$DEN_USER"
den::env::default 'WORKSPACE_LOCAL_KEY' 'local'
den::env::default 'WORKSPACE_NOTES_KEY' 'notes'

alias prosp="cd $WORKSPACE_DIR/$WORKSPACE_PRO_KEY"
alias localsp="cd $WORKSPACE_DIR/$WORKSPACE_LOCAL_KEY"
alias notessp="cd $WORKSPACE_DIR/$WORKSPACE_NOTES_KEY"
alias vaultsp="cd $WORKSPACE_DIR/vault"
