source "${0:h}/shpotify.sh"

alias spotify='shpotify'

function splay() {
  title="$@"

  if [[ -n "$title" ]]; then
    shpotify play $title
  else
    shpotify pause
  fi
}
