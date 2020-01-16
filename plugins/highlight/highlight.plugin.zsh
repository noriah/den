__HIGHLIGHTER_PATH="${0:h}/zsh-syntax-highlighting/"

function highlight_do_update () {
  BASE_URL="https://raw.githubusercontent.com/zsh-users/zsh-syntax-highlighting/master"

  echo "Updating highlight"

  for i in ${__HIGHLIGHTER_PATH}**/[^.]*[^.zwc](.)
  do
    u="$BASE_URL/${i#${__HIGHLIGHTER_PATH}}"
    curl -s "$u" > "$i"
  done
}

source "${0:h}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
