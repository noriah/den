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
  options.den.apps.i3.enable = mkEnableOption "i3wm";

  config = mkIf cfg.enable {

    home.packages = [ pkg.i3 ];

    xdg.configFile.i3 = {
      source = "${config.den.dir.etc}/i3";
      force = true;
    };

  };
}
