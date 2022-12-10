if (( $+commands[neofetch] )); then
  alias neofetch="neofetch --config $FETCH_CONFIG --ascii $FETCH_ASCII --ascii_colors $FETCH_COLORS"
else
  burrow::plugin::fail
fi
