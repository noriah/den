#!/usr/bin/env zsh

# Setup
ZSH_CACHE_DIR="$HOME/.cache/zsh"

[ ! -d "$ZSH_CACHE_DIR" ] && mkdir -p "$ZSH_CACHE_DIR"

ZSH_COMP_FILE="$ZSH_CACHE_DIR/.zcompdump"

ZSH_DIR="$DEN"
ZSH_BASE_DIR="$DEN/$FOX_DEN/base"
ZSH_CONF_DIR="$ZSH_DIR/etc"
ZSH_LIB_DIR="$DEN/$FOX_DEN/pkg"
ZSH_PLUGIN_DIR="$DEN/$FOX_DEN/plugins"

EDITOR=vi

CORP_KEY=${CORP_KEY:-corp}

# Zrc
denScript zrc.zsh

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

zrc plugins "$ZSH_CONF_DIR/plugins-osx"

denLoad home

# Zrc stuff
zrc do autoload
zrc do hook
