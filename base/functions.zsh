function env_default() {
    (( ${${(@f):-$(typeset +xg)}[(I)$1]} )) && return 0
    export "$1=$2" && return 3
}
