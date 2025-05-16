{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.openrgb;
in
{
  options.den.apps.openrgb.enable = mkEnableOption "openrgb control";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.openrgb
      pkgs.openrgb-plugin-effects
      pkgs.openrgb-plugin-visual-map
    ];

    xdg.configFile = {
      openrgb-plugin-effects = {
        target = "OpenRGB/plugins/libOpenRGBEffectsPlugin.so";
        source = "${pkgs.openrgb-plugin-effects}/lib/openrgb/plugins/libOpenRGBEffectsPlugin.so";
        force = true;
      };

      openrgb-plugin-visual-map = {
        target = "OpenRGB/plugins/libOpenRGBVisualMapPlugin.so";
        source = "${pkgs.openrgb-plugin-visual-map}/lib/openrgb/plugins/libOpenRGBVisualMapPlugin.so";
        force = true;
      };
    };
  };
}
