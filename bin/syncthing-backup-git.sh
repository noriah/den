#!/bin/sh

SOURCE_PATH="/data/noriah/sync/notes/"
DEST_PATH="/data/noriah/git/notes/"

folderpath="$1"
filepath="$2"

rsync -avh "${SOURCE_PATH}" "${DEST_PATH}" --delete --exclude=/.git

cd "${DEST_PATH}"

git add .
git commit -m "`date +'%Y-%m-%d %H:%M:%S'` - $filepath"

rm "${folderpath}/${filepath}"

exit 0
