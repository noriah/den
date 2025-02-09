den::user::set::color() {
  export DEN_USER_COLOR=$1
}

den::user::get::color() {
  echo $DEN_USER_COLOR
}
