# fzf

burrow plugin-fail

_BURROW_LIB_FZF=libfzf
burrow lib $_BURROW_LIB_FZF github/junegunn/fzf

local libfzfDir=$(burrow path $_BURROW_LIB_FZF)

if [[ -d ${libfzfDir} ]]; then

  if [[ ! "$PATH" == *${libfzfDir}/bin* ]]; then
    PATH="${PATH:+${PATH}:}${libfzfDir}/bin"
  fi

  if ! (( $+commands[fzf] )); then
    $libfzfDir/install \
      --bin \
      --no-bash --no-fish \
      --no-update-rc --key-bindings --completion
  fi

  [[ $- == *i* ]] && source "$libfzfDir/shell/completion.zsh" 2> /dev/null
  source "$libfzfDir/shell/key-bindings.zsh"

  bindkey -r '^T'
  bindkey -M emacs '^f' fzf-file-widget
  bindkey -M vicmd '^f' fzf-file-widget
  bindkey -M viins '^f' fzf-file-widget

  burrow plugin-pass
fi

unset libfzfDir
