() {
  emulate -L zsh

  if ! type "pkg-config" > /dev/null; then
    zash_fail "Missing pkg-config"
    return
  fi

  if ! type "greadlink" > /dev/null; then
    zash_fail "Missing coreutils"
    return
  fi
}

pkg-with-all () {
  local greadlink="/usr/local/bin/greadlink"
  local pkgpath
  for i in /usr/local/opt/*/
  do
    if [ -d ${i}lib/pkgconfig ]; then
      pkgpath="$pkgpath:$($greadlink -f ${i})/lib/pkgconfig"
    fi
  done

  PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${pkgpath}" $@
}

pkg-export-all () {
  local pkgpath
  local greadlink="/usr/local/bin/greadlink"
  for i in /usr/local/opt/*/
  do
    if [ -d ${i}lib/pkgconfig ]; then
      pkgpath="$pkgpath:$($greadlink -f ${i})/lib/pkgconfig"
    fi
  done

  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${pkgpath}"
}
