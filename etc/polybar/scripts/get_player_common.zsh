#!/usr/bin/env zsh

getPlayer() {
  local _player="$(playerctl metadata --format="{{ playerName }}" 2>&1)"

  case "$_player" in
    spotify)
      PLAYER=spotify
      ;;

    vlc)
      PLAYER=vlc
      ;;

    *)
      echo ${@:-$_player}
      ;;

  esac

  unset _player

  export PLAYER
}
