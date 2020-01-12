source "${0:h}/powerlevel10k/powerlevel10k.zsh-theme"

P10K_PATH="${0:h}/powerlevel10k/"

function p10k_do_update () {
  BASE_URL="https://raw.githubusercontent.com/romkatv/powerlevel10k/master"

  echo "Updating powerlevel10k"

  for i in ${P10K_PATH}**/[^.]*[^.zwc](.)
  do
    u="$BASE_URL/${i#${P10K_PATH}}"
    curl -s "$u" > "$i"
  done
}
