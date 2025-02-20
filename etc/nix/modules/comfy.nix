{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.modules.comfy;
in
{
  options.den.modules.comfy.enable = mkEnableOption "comfy module";

  config = mkIf cfg.enable {
    den.apps.neofetch.enable = true;
  };
}
