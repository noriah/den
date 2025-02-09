# fzf

burrow::plugin::fail

burrow lib libfzf github/junegunn/fzf

local libfzfDir=$(burrow path libfzf)

if [[ -d ${libfzfDir} ]]; then

  den::path::add "${libfzfDir}/bin"

  if ! (( $+commands[fzf] )); then
    $libfzfDir/install \
      --bin \
      --no-bash --no-fish \
      --no-update-rc --key-bindings --completion
  fi

  # [[ $- == *i* ]] && source "$libfzfDir/shell/completion.zsh" 2> /dev/null
  # source "$libfzfDir/shell/key-bindings.zsh"
  source <(fzf --zsh)

  burrow::plugin::pass
fi

unset libfzfDir
