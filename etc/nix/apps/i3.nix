{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.i3;
in
{
  options.den.apps.i3 = {
    enable = mkEnableOption "i3wm";

    package = mkPackageOption pkgs "i3" { };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    xdg.configFile.i3 = {
      source = "${config.den.etcDir}/i3";
      force = true;
    };

  };
}
