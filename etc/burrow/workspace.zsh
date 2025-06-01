# export WORKSPACE_DIR="/space/nor"
# WORKSPACE_PUBLIC_KEY=public
# WORKSPACE_NOTES_KEY=notes
# WORKSPACE_LOCAL_KEY=local
# WORKSPACE_VAULT_KEY=vault

# TODO(transition): move this into workspace nix home module

scs_dir="${WORKSPACE_DIR}/split-cube"

typeset -g WORKSPACE_DIR_CLASSES_EXTRA=(
  "$scs_dir|$scs_dir/*" WORKSPACE_SCS '%B\U000f141c'
)

typeset -g POWERLEVEL9K_DIR_WORKSPACE_SCS_VISUAL_IDENTIFIER_COLOR=157
