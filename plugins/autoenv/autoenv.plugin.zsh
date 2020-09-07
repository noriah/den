__AUTOENV_PATH="${0:h}/zsh-autoenv/"

autoenv_do_update () {
  BASE_URL="https://raw.githubusercontent.com/Tarrasch/zsh-autoenv/master"

  echo "Updating autoenv"

  for i in ${__AUTOENV_PATH}**/[^.]*[^.zwc](.)
  do
    u="$BASE_URL/${i#${__AUTOENV_PATH}}"
    curl -s "$u" > "$i"
  done
}

source "${0:h}/zsh-autoenv/autoenv.zsh" || zrc_fail "3rd party failure"
