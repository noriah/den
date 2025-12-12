{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.xorg;
in
{
  options.den.apps.xorg.enable = mkEnableOption "xorg tools and config";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      xcolor
    ];

    home.file.".Xresources" = {
      source = "${config.den.dir.etc}/xorg/Xresources";
    };

  };
}
