# ersa is an AMD Desktop running Linux
den::conf linux.zsh

burrow plugin vim_mode

# GCP SDK
# GCP_SDK=""
# burrow plugin gcloud

# SSH Specific things
SSH_HOST_SOCK="${HOME}/.1password/agent.sock"
burrow plugin ssh

burrow plugin tmux

# Set our prompt icon color
export POWERLEVEL9K_DISABLE_GITSTATUS=true
export POWERLEVEL9K_OS_ICON_FOREGROUND=204
export POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=164
