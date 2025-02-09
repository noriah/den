den::host::set::color() {
  export DEN_HOST_COLOR=$1
}

den::host::get::color() {
  echo $DEN_HOST_COLOR
}

