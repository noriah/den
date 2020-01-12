# Setup
ZSH_CACHE_DIR="$HOME/.cache/zsh"

mkdir -p "${ZSH_CACHE_DIR}"

ZSH_COMP_FILE="${ZSH_CACHE_DIR}/.zcompdump"

ZSH_DIR="${0:h}"
ZSH_BASE_DIR="${ZSH_DIR}/base"
ZSH_CONF_DIR="${ZSH_DIR}/conf"
ZSH_LIB_DIR="${ZSH_DIR}/lib"
ZSH_PLUGIN_DIR="${ZSH_DIR}/plugins"

EDITOR=vi

WORKSPACE_DIR="$HOME/workspace"

CORP_KEY=${CORP_KEY:-corp}

# Zash
source "${0:h}/zash.zsh"

# Base
zash base alias
zash base appearance
zash base completion
zash base directory
zash base functions
zash base history
zash base keys
zash base load
zash base misc
zash base terminal

env_default 'PAGER' 'less'
env_default 'LESS' '-R'

# Plugins
zash plugin osx
zash plugin spotify
zash plugin todo
zash plugin z

# Theme
zash library p10k

