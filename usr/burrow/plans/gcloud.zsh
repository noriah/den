# GCP
env_default 'GCP_SDK' "$HOME_OPT/google-cloud-sdk"

export_once 'PATH' "$PATH:$GCP_SDK/bin"

[ -d "$GCP_SDK" ] && . "$GCP_SDK/completion.zsh.inc"
