{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.packs.fonts;
in
{
  options.den.packs.fonts.enable = mkEnableOption "fonts module";

  config = mkIf cfg.enable {

    xdg.configFile.nix-fonts = {
      target = "fontconfig/conf.d/100-nix.conf";
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <!-- NIX_PROFILE is the path to your Nix profile. See Nix Reference Manual for details. -->
          <dir prefix="cwd">NIX_PROFILE/lib/X11/fonts</dir>
          <dir prefix="cwd">NIX_PROFILE/share/fonts</dir>
        </fontconfig>
      '';
      force = true;
    };

    xdg.dataFile.fonts = {
      target = "fonts";
      source = "${config.den.dir.share}/fonts";
      recursive = true;
    };
  };
}
