{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.packs.comfy;
in
{
  options.den.packs.comfy.enable = mkEnableOption "comfy module";

  config = mkIf cfg.enable {
    den.apps = {
      neofetch.enable = mkDefault true;
    };

    den.packs = { };
  };
}
