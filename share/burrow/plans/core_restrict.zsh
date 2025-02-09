den::env::default 'CORE_RESTRICT_IGNORE_CORES' 2
den::env::default 'CORE_RESTRICT_LAST_CORE' $(lscpu -p | tail -n 1 | cut -d, -f 1)

core_restrict() {
  local _ignore=$CORE_RESTRICT_IGNORE_CORES
  local _last=$CORE_RESTRICT_LAST_CORE
  local _list="$_ignore-$(($_last / 2)),$(($_last / 2 + $_ignore + 1))-$_last"

  taskset -a -c $_list "$@"
}
