#!/usr/bin/env zsh

burrow::download::repo() {
  local burrowName="$1"
  local burrowDir="$2"
  local repoURI="$3"
  if [[ ! -d "$burrowDir" || ! -d "$burrowDir/.git" ]]; then

      printf "*** digging for '%s' in the clouds ('%s').\n" "$burrowName" "$repoURI"

      local repoURL

      case "$repoURI" in

        github/*)
          repoURL="https://github.com${repoURI#"github"}"
          ;;

        *)
          repoURL="$repoURI"
          ;;
      esac

      retTxt=$(git clone "$repoURL" "$burrowDir" 2>&1 1>/dev/null )
      ret="$?"

      if [ ! "$ret" -eq 0 ]; then

        printf "*** sorry! i could not get you that repo. here is the address i tried:\n\n\t%s\n\n" "$repoURL"

        printf "*** and here is the error:\n\n\t%s\n\n" "$retTxt"

        return $ret

      fi

      printf "*** done with that! (%s)\n" "$burrowName"
    fi

    return 0
}

burrow::plugin() {

  local burronDir
  local burrowName
  local burrowFile
  local burrowConf
  local burrowLight
  local repoURI

  case "$#" in
    0)
      printf "*** uh oh. please add some arguments for me to process!\n"
      return 1
      ;;

    1)
      # printf "loading up '%s'!\n" "$1"
      if [ ! -f "$1" ]; then
        burrowLight=1
      #	printf "*** uh oh. i could not find '%s'. try again later?\n" "$1"
      #	return 1
      fi

      burrowDir="$(dirname $1)"
      burrowFile="$(basename $1)"
      burrowName="${burrowFile%.zsh}"

      # hack: support local plans
      if [ -f "$DEN/share/burrow/plans/$burrowName.zsh" ]; then
        burrowDir="$DEN/share/burrow/plans"
        burrowFile="$burrowName.zsh"
        burrowLight=0
      fi
      ;;

    2)
      if [[ -d "$1" && -f "$1/$2" ]]; then
        # printf "*** digging for '%s' in '%s'.\n" "$2" "$1"
        burrowDir="$(dirname $1/$2)"
        burrowFile="$(basename $2)"
        burrowName="${burrowFile%.zsh}"
      else
        burrowDir="$BURROW_OPT/$(basename $(dirname $1))_$(basename $1)"
        burrowFile="$2"
        burrowName="$(basename $1)"
        if [[ ! -d "$burrowDir" || ! -d "$burrowDir/.git" || ! -f "$burrowDir/$burrowFile" ]]; then
          repoURI="$1"
        fi
      fi
      ;;

    3)
      burrowDir="$BURROW_OPT/$(basename $(dirname $2))_$(basename $2)"
      burrowFile="$3"
      burrowName="$1"
      # if [[ ! -d "$burrowDir" || ! -d "$burrowDir/.git" || ! -f "$burrowDir/$burrowFile" ]]; then
      repoURI="$2"
      # fi
      ;;

    *)
      printf "*** what am i supposed do with this garbage '%s'?\n" "${@:4}"
      return 1
      ;;
  esac

  # TODO: check for already existing burrow

  if [ ! -d "$BURROW_OPT" ]; then
    mkdir "$BURROW_OPT"
  fi

  # Repo Download
  if [ ! -z "$repoURI" ]; then

    burrow::download::repo "$burrowName" "$burrowDir" "$repoURI"

    local ret="$?"
    if [ ! "$ret" -eq 0 ]; then
      return $ret
    fi

    if [ ! -f "$burrowDir/$burrowFile" ]; then
      printf "*** uh oh! i did not find '%s' in '%s' (%s)!\n." "$burrowFile" "$repoURI" "$burrowName"

      return 1
    fi

    _DEN_BURROW_REPO_LIST[$burrowName]="$(basename "$burrowDir")"

  fi

  local burrowConf="$DEN/etc/burrow/$burrowName.zsh"

  export _DEN_BURROW_PLUGIN_LOAD_FAIL=0

  [[ -f "$burrowConf" ]] && . "$burrowConf"

  [[ ! "$burrowLight" -eq "1" ]] && . "$burrowDir/$burrowFile"


  [ $_DEN_BURROW_PLUGIN_LOAD_FAIL -eq 0 ] && _DEN_BURROW_LIST+=( "$burrowName" )

  unset _DEN_BURROW_PLUGIN_LOAD_FAIL

  return 0
}

burrow::plugin::fail() {
  export _DEN_BURROW_PLUGIN_LOAD_FAIL=1
}

burrow::plugin::pass() {
  export _DEN_BURROW_PLUGIN_LOAD_FAIL=0
}

burrow::check() {
  [[ ${_DEN_BURROW_LIST[(ie)$1]} -le ${#_DEN_BURROW_LIST} ]] && return 0 || return 1
}

burrow::lib() {

  local burrowDir
  local burrowName
  local repoURI

  case "$#" in
    0)
      printf "*** uh oh. please add some arguments for me to process!\n"
      return 1
      ;;
    2)
      burrowDir="$BURROW_OPT/$(basename $(dirname $2))_$(basename $2)"
      burrowName="$(basename $1)"
      repoURI="$2"
      ;;
    *)
      printf "*** what am i supposed do with this garbage '%s'?\n" "$4"
      return 1
      ;;
  esac

  # Repo Download
  if [ ! -z "$repoURI" ]; then

    burrow::download::repo "$burrowName" "$burrowDir" "$repoURI"

    local ret="$?"
    if [ ! "$ret" -eq 0 ]; then
      return $ret
    fi

    _DEN_BURROW_REPO_LIST[$burrowName]="$(basename "$burrowDir")"

  fi

  _DEN_BURROW_LIST+=( "$burrowName" )
}

burrow::path() {
  if burrow::check $1; then
    if [[ -v _DEN_BURROW_REPO_LIST["$1"] ]]; then
      echo "$BURROW_OPT/$_DEN_BURROW_REPO_LIST[$1]";
      return 0
    fi
  fi

  return 1
}

burrow::update() {
  for burrowName in ${(k)_DEN_BURROW_REPO_LIST}; do
    printf "*** updating '%s' from the clouds.\n" "$burrowName"
    local burrowDir="$BURROW_OPT/$_DEN_BURROW_REPO_LIST[$burrowName]"

    if [ ! -d "$burrowDir/.git" ]; then
      printf "*** why is '%s' not a git repo? (%s)\n" "$burrowDir" "$burrowName"
      continue
    fi

    retTxt=$(git -C "$burrowDir" pull 2>&1 1>/dev/null)
    ret="$?"

    if [ ! "$ret" -eq 0 ]; then
      printf "*** sorry! i hit an error with that (%s):\n\n" "$burrowName"
      printf "*** here is the error:\n\n\t%s\n\n" "$retTxt"
      continue
    fi

    printf "*** done with that! (%s)\n" "$burrowName"
  done

  printf "*** all done with updates! restart your shell for updates to take effect.\n"
}

burrow() {
  case "$1" in
    plugin) burrow::plugin "${@:2}" ;;
    lib) burrow::lib "${@:2}" ;;
    path) burrow::path "${@:2}" ;;
    check) burrow::check "${@:2}" ;;
    update) burrow::update ;;
    *) return 1 ;;
  esac
}
