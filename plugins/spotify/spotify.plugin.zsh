source "${0:h}/shpotify.sh" || zrc_fail "3rd party failure"

alias spotify='shpotify'

splay() {
  title="$@"

  if [[ -n "$title" ]]; then
    shpotify play $title
  else
    shpotify pause
  fi
}
