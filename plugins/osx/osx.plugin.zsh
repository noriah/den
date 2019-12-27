function vncviewer() {
  open vnc://$@
}

# Remove .DS_Store files recursively in a directory, default .
function rmdsstore() {
	find "${@:-.}" -type f -name .DS_Store -delete
}

OSX_CAPTURE_FOLDER="$HOME/Desktop"

function cap() {
  screencapture "${OSX_CAPTURE_FOLDER}/capture-$(date +%Y%m%d_%H%M%S).png"
}

function capi() {
  screencapture -i "${OSX_CAPTURE_FOLDER}/capture-$(date +%Y%m%d_%H%M%S).png"
}

function capiw() {
  screencapture -i -w "${OSX_CAPTURE_FOLDER}/capture-$(date +%Y%m%d_%H%M%S).png"
}

alias capc="screencapture -c"
alias capic="screencapture -i -c"
alias capiwc="screencapture -i -w -c"
