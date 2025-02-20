{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.neofetch;
in
{
  options.den.apps.neofetch = {
    enable = mkEnableOption "neofetch";

    package = mkPackageOption pkgs "neofetch" { };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    xdg.configFile.neofetch_config = {
      target = "neofetch/config.conf";
      source = "${config.den.dir.etc}/neofetch/config.conf";
      force = true;
    };
  };
}
