env_default 'BURROW_OPT' "$HOME/opt/burrow"

fnPath="${0:h:A}/fn"

fpath=("$fnPath" "${fpath[@]}")

for func in $^fnPath/*; autoload -Uz $func

unset fnPath
