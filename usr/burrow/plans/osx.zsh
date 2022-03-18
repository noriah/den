vncviewer() {
  open vnc://$@
}

# Remove .DS_Store files recursively in a directory, default .
rmdsstore() {
	find "${@:-.}" -type f -name .DS_Store -delete
}

OSX_CAPTURE_FOLDER="$HOME/Desktop"

cap() {
  screencapture "${OSX_CAPTURE_FOLDER}/capture-$(date +%Y%m%d_%H%M%S).png"
}

capi() {
  screencapture -i "${OSX_CAPTURE_FOLDER}/capture-$(date +%Y%m%d_%H%M%S).png"
}

capiw() {
  screencapture -i -w "${OSX_CAPTURE_FOLDER}/capture-$(date +%Y%m%d_%H%M%S).png"
}

alias capc="screencapture -c"
alias capic="screencapture -i -c"
alias capiwc="screencapture -i -w -c"
