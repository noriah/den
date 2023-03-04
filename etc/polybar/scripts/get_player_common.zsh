#!/usr/bin/env zsh

getPlayerRaw() {
  echo "$(playerctl metadata --format="{{ playerName }}" 2>&1)"
}

getPlayer() {
  local _player="$(getPlayerRaw)"

  case "$_player" in
    spotify)
      echo spotify
      ;;

    vlc)
      echo vlc
      ;;

    *)
      echo ${@:-$_player}
      ;;
  esac

  unset _player
}
