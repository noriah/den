den::install::checkBackupHome '.gitconfig'

echo "creating user git config."

sed "s|IGNORE_FILE_LOCATION|$FOX_DEN/etc/git/global.gitignore|" \
  "$FOX_DEN/etc/git/global.gitconfig" > "$HOME/.gitconfig"
