# niji is an AMD Desktop running Linux
export WORKSPACE_DIR="$HOME/space"

den::conf linux.zsh

den::host::set::color 135
den::user::set::color 204

# burrow plugin vim_mode

# GCP SDK
# GCP_SDK=""
# burrow plugin gcloud

# SSH Specific things
SSH_HOST_SOCK="${HOME}/.1password/agent.sock"
burrow plugin ssh

burrow plugin tmux

burrow plugin tor

burrow plugin home-manager
