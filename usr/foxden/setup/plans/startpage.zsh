echo "building startpage."

BUILD_SCRIPT="$FOX_DEN/usr/startpage/build.zsh"

if [ -f "$BUILD_SCRIPT" ]; then
  if !"$BUILD_SCRIPT"; then; else
    echo "failed to make startpage. make sure you have sass installed."
    echo "no changes made."
    exit 1
  fi
fi

#echo "done."
