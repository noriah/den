#!/usr/bin/env zsh

case "$1" in
  load)
    awk '
      /LOADPCT/ { p=$2 }
      /NOMPOWER/ { n=$2 }
      /END APC/ { printf "%d\n",(n * (p/100)) }' < /tmp/apcaccess.out
    ;;
  events)
    awk '/NUMXFERS/ { print $2 }' < /tmp/apcaccess.out
    ;;
  *) ;;
esac
#!/usr/bin/env zsh
