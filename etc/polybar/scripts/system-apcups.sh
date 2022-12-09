#!/bin/sh

case "$1" in
  load)
    unbuffer python3 ~/dbin/apcaccess.py -f 1 LOADPCT NOMPOWER | awk '
      /LOADPCT/ { p=$2 }
      /NOMPOWER/ { printf "%3d\n",($2 * (p/100)) }'
    ;;
  *) ;;
esac
