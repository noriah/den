__SUGGESTIONS_PATH="${0:h}/zsh-autosuggestions/"

suggestions_do_update () {
  BASE_URL="https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master"

  echo "Updating suggestions"

  for i in ${__SUGGESTIONS_PATH}**/[^.]*[^.zwc](.)
  do
    u="$BASE_URL/${i#${__SUGGESTIONS_PATH}}"
    curl -s "$u" > "$i"
  done
}

source "${0:h}/zsh-autosuggestions/zsh-autosuggestions.zsh" || zash_fail "3rd party failure"
