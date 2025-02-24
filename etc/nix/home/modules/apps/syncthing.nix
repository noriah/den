{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.syncthing;
in
{
  options.den.apps.syncthing.enable = mkEnableOption "syncthing";

  config = mkIf cfg.enable {
    # xdg.configFile = {}

    services.syncthing.enable = true;
  };
}
