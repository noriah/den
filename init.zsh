# Setup
ZSH_CACHE_DIR="$HOME/.cache/zsh"

[ ! -d "$ZSH_CACHE_DIR" ] && mkdir -p "$ZSH_CACHE_DIR"

ZSH_COMP_FILE="$ZSH_CACHE_DIR/.zcompdump"

ZSH_DIR="${0:h}"
ZSH_BASE_DIR="$ZSH_DIR/base"
ZSH_CONF_DIR="$ZSH_DIR/conf"
ZSH_LIB_DIR="$ZSH_DIR/lib"
ZSH_PLUGIN_DIR="$ZSH_DIR/plugins"

EDITOR=vi

CORP_KEY=${CORP_KEY:-corp}

# Zrc
source "${0:h}/zrc.zsh"

# Base
zrc base alias
zrc base appearance
zrc base completion
zrc base directory
zrc base functions
zrc base history
zrc base keys
zrc base load
zrc base misc
zrc base terminal

env_default 'PAGER' 'less'
env_default 'LESS' '-R'

zrc plugins "${0:h}/plugins-osx"

# Theme
zrc library p10k
zrc library z

# Zrc stuff
zrc do autoload
zrc do hook
