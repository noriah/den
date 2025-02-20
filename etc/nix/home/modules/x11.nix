{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.modules.x11;
in
{
  options.den.modules.x11.enable = mkEnableOption "x11 module";

  config = mkIf cfg.enable {
    home.file.".Xresources" = {
      source = "${config.den.dir.etc}/xorg/Xresources";
    };
  };
}
