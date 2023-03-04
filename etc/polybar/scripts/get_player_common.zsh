#!/usr/bin/env zsh

getPlayerRaw() {
  echo "$(playerctl metadata --format="{{ playerName }}" 2>&1)"
}

getPlayer() {
  case "$(getPlayerRaw)" in
    spotify)
      echo spotify
      ;;

    vlc)
      echo vlc
      ;;

    *)
      echo ${@:-spotify}
      ;;
  esac
}
