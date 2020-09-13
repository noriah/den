env_default 'BURROW_OPT' "$HOME/opt/burrow"

fnPath="${0:h:A}/fn"

fpath=("$fnPath" "${fpath[@]}")

for func in $^fnPath/*; do
	autoload -Uz $func
done

unset fnPath
