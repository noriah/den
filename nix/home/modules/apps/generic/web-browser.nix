{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let

  cfg = config.den.apps.web-browser;
in
{
  options.den.apps.web-browser = {
    enable = mkEnableOption "web-browser";

    package = mkPackageOption pkgs "firefox" { };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

  };
}
