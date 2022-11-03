# vyxn is a MacBook Pro running macOS
denConf macos.zsh

# We have a battery
burrow plugin battery

# GCP SDK
# GCP_SDK=""
# burrow plugin gcloud

# SSH Specific things
unset SSH_AUTH_SOCK
SSH_HOST_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
burrow plugin ssh

# Set our prompt icon color
export POWERLEVEL9K_OS_ICON_FOREGROUND=201
