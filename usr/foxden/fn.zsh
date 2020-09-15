#!/usr/bin/env zsh

function denConf() {
	[ -f "$FOX_DEN/etc/den/$1" ] && source "$FOX_DEN/etc/den/$1"
	return "$?"
}

function denSource() {
	if [ -f "$FOX_DEN/$1" ]; then
		source "$FOX_DEN/$1"
		return 0
	fi
	printf "sorry! i could not find '%s' in '%s'.\n" "$1" "$FOX_DEN" 1>&2
	return 1
}
