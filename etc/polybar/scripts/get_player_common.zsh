#!/usr/bin/env zsh

getPlayer() {
  # local _player="$(playerctl metadata --format="{{ playerName }}" 2>&1)"

  case "$_player" in
    spotify|spotify|*)
      PLAYER="$_player"
      ;;

  esac

  unset _player

  PLAYER=spotify

  export PLAYER
}
