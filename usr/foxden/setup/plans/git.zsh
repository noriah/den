den::install::checkBackupHome '.gitconfig'

echo "creating user git config."

sed "s|IGNORE_FILE_LOCATION|$HOME_ETC/git/global.gitignore|" \
  "$HOME_ETC/git/global.gitconfig" > "$HOME/.gitconfig"
