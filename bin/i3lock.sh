#!/bin/sh

I3LOCK_ARGS="--ignore-empty-password --nofork --fuzzy --sigma 25.0 --radius 98 --once"

revert() {
  xset dpms 0 0 0
}
trap revert HUP INT TERM
xset +dpms dpms 5 5 5
i3lock $I3LOCK_ARGS
revert
