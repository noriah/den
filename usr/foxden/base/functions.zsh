env_default() {
  (( ${${(@f):-$(typeset +xg)}[(I)$1]} )) && return 0
  export "$1=$2" && return 3
}

# Set the value only if we are in shell level 1
export_once() {
  if [ ${FOX_DEN_ZSHRC_RUN:=0} -ne 1 ]; then
    export "$1=$2" && return 0
  fi
}

isMac() {
  [[ $OSTYPE =~ darwin ]] && return 0 || return 1
}

isLinux() {
  [[ $OSTYPE =~ linux ]] && return 0 || return 1
}
