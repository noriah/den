{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.screenshot;
in
{
  options.den.apps.screenshot.enable = mkEnableOption "screenshot";

  config = mkIf cfg.enable {

    home.packages = [
      "ksnip"
    ];

  };
}
