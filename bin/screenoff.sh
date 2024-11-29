#!/bin/sh

revert() {
  xset dpms 0 0 0
}
trap revert HUP INT TERM
xset +dpms dpms 9 9 9
revert
