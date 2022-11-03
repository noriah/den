# GCP
den::env::default 'GCP_SDK' "$HOME_OPT/google-cloud-sdk"

den::export_once 'PATH' "$PATH:$GCP_SDK/bin"

[ -d "$GCP_SDK" ] && . "$GCP_SDK/completion.zsh.inc"
