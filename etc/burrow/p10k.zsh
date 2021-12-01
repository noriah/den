# Powerlevel10k Config
# Noriah (vix@noriah.dev)

# echo ${(pl.$LINES..\n.)}

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

function left() {
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS+=("$@")
}

function leftPlugin() {
  if burrow check "$1"; then
    (( ${+2} )) && shift
    left $@
  fi
}

function right() {
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=("$@")
}

function rightPlugin() {
  if burrow check "$1"; then
    (( ${+2} )) && shift
    right $@
  fi
}

() {
  emulate -L zsh

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  setopt no_unset extended_glob

  autoload -Uz is-at-least && is-at-least 5.1 || return

  zmodload zsh/langinfo

  if [[ ${langinfo[CODESET]:-} != (utf|UTF)(-|)8 ]]; then
    local LC_ALL=${${(@M)$(locale -a):#*.(utf|UTF)(-|)8}[1]:-en_US.UTF-8}
  fi

  typeset -g ZLE_RPROMPT_INDENT=0

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT=2

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir

  typeset -g POWERLEVEL9K_INSTANT_PROMPT_COMMAND_LINES=0
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  typeset -g POWERLEVEL9K_MODE=nerdfont-complete

  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
  typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
  typeset -g POWERLEVEL9K_DISABLE_INSTANT_PROMPT=false

  # typeset -g POWERLEVEL9K_ICON_PADDING=none

  typeset -ga POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  typeset -ga POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS

  ###
  # left prompt elements
  left os_icon
  left dir dir_writable
  left vcs
  left blank newline
  left status

  ###
  # right prompt elements
  right command_execution_time
  right background_jobs

  rightPlugin battery

  right context
  # right load
  right newline

  rightPlugin direnv
  rightPlugin terraform

  # right virtualenv pyenv goenv nodenv
  right ranger vim_shell vpn_ip

  rightPlugin golang go_version

  rightPlugin rust rust_version

  rightPlugin node node_version

  rightPlugin taskwarrior

  rightPlugin todo

  ### Stuffs

  #typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=''
  #typeset -g POWERLEVEL9K_LEGACY_ICON_SPACING=false

  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER// }'

  typeset -g POWERLEVEL9K_{BACKGROUND_JOBS,DIRENV,VIM_SHELL,VPN_IP}_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER// }'

  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=''
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_GAP_BACKGROUND=

  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B1'
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B3'
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0BC'
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0BA'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B1'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B3'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  #typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  #typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL

  env_default 'POWERLEVEL9K_OS_ICON_FOREGROUND' 7
  # typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=0
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='λ'
  #typeset -g POWERLEVEL9K_OS_ICON_LEFT_LEFT_WHITESPACE=''

  typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE,ERROR,ERROR_SIGNAL,ERROR_PIPE}=true
  typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE}_VISUAL_IDENTIFIER_EXPANSION=$'\u2714'
  typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE}_FOREGROUND=2
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

  typeset -g POWERLEVEL9K_STATUS_CROSS=false
  typeset -g POWERLEVEL9K_STATUS_SHOW_PIPESTATUS=true

  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_VISUAL_IDENTIFIER_EXPANSION=$'\u2718'
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_FOREGROUND=196
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=true
  typeset -g POWERLEVEL9K_STATUS_HIDE_SIGNAME=true
  #typeset -g POWERLEVEL9K_STATUS_LEFT_LEFT_WHITESPACE=''

  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
  # typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='>'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='Ⅴ'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  #typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_RIGHT_WHITESPACE=

  typeset -g POWERLEVEL9K_DIR_FOREGROUND=80
  typeset -g POWERLEVEL9K_DIR_{SHORTENED,ANCHOR}_FOREGROUND=80
  typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER// }'
  # typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER
  # typeset -g POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND=210
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=40

  typeset -g POWERLEVEL9K_DIR_CLASSES=(
    '/etc|/etc/*' ETC '\uF013'
    '~' HOME '\uF015'
    "$FOX_DEN|$FOX_DEN/*" FOX_DEN '%B\uF737'
  )

  typeset -g POWERLEVEL9K_DIR_FOX_DEN_VISUAL_IDENTIFIER_COLOR=196

  if burrow check 'workspace'; then
    local pro_dir="$WORKSPACE_DIR/$WORKSPACE_PRO_KEY"
    local local_dir="$WORKSPACE_DIR/$WORKSPACE_LOCAL_KEY"
    local notes_dir="$WORKSPACE_DIR/$WORKSPACE_NOTES_KEY"
    local vault_dir="$WORKSPACE_DIR/vault"

    POWERLEVEL9K_DIR_CLASSES+=(
      "$WORKSPACE_DIR" WORKSPACE '%B\uF44F'
      "$pro_dir|$pro_dir/*" WORKSPACE_PRO '%B\uE780'
      "$local_dir|$local_dir/*" WORKSPACE_LOCAL '%B\uF7C9'
      "$notes_dir|$notes_dir/*" WORKSPACE_NOTES '%B\uFD2C'
      "$vault_dir|$vault_dir/*" WORKSPACE_VAULT '%B\uFC71'
    )

    typeset -g POWERLEVEL9K_DIR_WORKSPACE_VISUAL_IDENTIFIER_COLOR=202
    typeset -g POWERLEVEL9K_DIR_WORKSPACE_PRO_VISUAL_IDENTIFIER_COLOR=210
    # typeset -g POWERLEVEL9K_DIR_WORKSPACE_PRO_FOREGROUND=209
    typeset -g POWERLEVEL9K_DIR_WORKSPACE_LOCAL_VISUAL_IDENTIFIER_COLOR=5
    # typeset -g POWERLEVEL9K_DIR_WORKSPACE_LOCAL_FOREGROUND=254
    typeset -g POWERLEVEL9K_DIR_WORKSPACE_NOTES_VISUAL_IDENTIFIER_COLOR=34
    typeset -g POWERLEVEL9K_DIR_WORKSPACE_VAULT_VISUAL_IDENTIFIER_COLOR=1
  fi

  POWERLEVEL9K_DIR_CLASSES+=(
    '~/*' HOME_SUBFOLDER '\uF07C'
    '*' DEFAULT '\uF115'
  )

  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='->'
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

  typeset -g POWERLEVEL9K_HISTORY_FOREGROUND=204
  # typeset -g POWERLEVEL9K_HISTORY_CONTENT_EXPANSION='%B${P9K_CONTENT}'

  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=2
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=3
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=2
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=3
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=8
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=6
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_{VERBOSE,VERBOSE_ALWAYS}=false

  typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=6
  typeset -g POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION=
  typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='(wg|(.*tun))[0-9]*'

  typeset -g POWERLEVEL9K_VI_COMMAND_MODE_STRING=NORMAL
  typeset -g POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND=2
  typeset -g POWERLEVEL9K_VI_VISUAL_MODE_STRING=VISUAL
  typeset -g POWERLEVEL9K_VI_MODE_VISUAL_FOREGROUND=4
  typeset -g POWERLEVEL9K_VI_OVERWRITE_MODE_STRING=OVERTYPE
  typeset -g POWERLEVEL9K_VI_MODE_OVERWRITE_FOREGROUND=3
  typeset -g POWERLEVEL9K_VI_INSERT_MODE_STRING=INSERT
  typeset -g POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND=8

  typeset -g POWERLEVEL9K_LOAD_WHICH=1
  typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=140
  typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=3
  typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=1

  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=3
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=1
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=2
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'

  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  typeset -g POWERLEVEL9K_{VIRTUALENV,PYENV,GOENV,NODEENV}_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_{VIRTUALENV,PYENV,GOENV,NODEENV}_{LEFT,RIGHT}_DELIMITER=
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_NODEENV_SHOW_NODE_VERSION=false

  typeset -g POWERLEVEL9K_TIME_FOREGROUND=159
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true

  if burrow check 'todo'; then
    typeset -g POWERLEVEL9K_TODO_FOREGROUND=3
    typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_TOTAL=false
    typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_FILTERED=false
    typeset -g POWERLEVEL9K_TODO_VISUAL_IDENTIFIER_EXPANSION=$'\u2611'
  fi

  if burrow check 'taskwarrior'; then
    typeset -g POWERLEVEL9K_TASKWARRIOR_FOREGROUND=7
  fi

  if burrow check 'battery'; then
    typeset -g POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD=100
    typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
    typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=1
    typeset -g POWERLEVEL9K_BATTERY_{CHARGING,CHARGED}_FOREGROUND=2
    typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=3
    typeset -g POWERLEVEL9K_BATTERY_STAGES=$'\uf58d\uf579\uf57a\uf57b\uf57c\uf57d\uf57e\uf57f\uf580\uf581\uf578'
    typeset -g POWERLEVEL9K_BATTERY_VERBOSE=true
  fi

  if burrow check 'golang'; then
    typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\ufcd1'
    typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_COLOR=87
    typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=11
  fi

  if burrow check 'rust'; then
    typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\uf827'
    typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_COLOR=166
    typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=11
  fi

  if burrow check 'node'; then
    typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
    # typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\u'
    typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_COLOR=10
    typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=11
  fi

  (( ! $+functions[p10k] )) || p10k reload
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'

unset -f left leftPlugin
unset -f right rightPlugin
