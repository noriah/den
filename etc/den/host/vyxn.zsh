# vyxn is a MacBook Pro running macOS
den::conf macos.zsh

# We have a battery
burrow plugin battery

# GCP SDK
# GCP_SDK=""
# burrow plugin gcloud

# SSH Specific things
SSH_HOST_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
burrow plugin ssh

burrow plugin tor

# Set our prompt icon color
den::host::set::color 201
