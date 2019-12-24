function vncviewer() {
  open vnc://$@
}

# Remove .DS_Store files recursively in a directory, default .
function rmdsstore() {
	find "${@:-.}" -type f -name .DS_Store -delete
}
