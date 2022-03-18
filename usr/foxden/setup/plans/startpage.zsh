echo "building startpage."

if !"$FOX_DEN/usr/startpage/build.zsh"; then; else
  echo "failed to make startpage. make sure you have sass installed."
  echo "no changes made."
  exit 1
fi

echo "done."
