{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  den_pkgs = pkgs.callPackage ../../../packages { };

  cfg = config.den.apps.openrgb;
in
{
  options.den.apps.openrgb.enable = mkEnableOption "openrgb control";

  config = mkIf cfg.enable {
    home.packages = [
      den_pkgs.openrgb
      den_pkgs.openrgb-plugin-effects
      den_pkgs.openrgb-plugin-visual-map
    ];

    # nixpkgs.overlays = (pkgs.callPackage ../../nixos/openrgb.nix { }).nixpkgs.overlays;

    xdg.configFile = {
      openrgb-plugin-effects = {
        target = "OpenRGB/plugins/libOpenRGBEffectsPlugin.so";
        source = "${den_pkgs.openrgb-plugin-effects}/lib/openrgb/plugins/libOpenRGBEffectsPlugin.so";
        force = true;
      };

      openrgb-plugin-visual-map = {
        target = "OpenRGB/plugins/libOpenRGBVisualMapPlugin.so";
        source = "${den_pkgs.openrgb-plugin-visual-map}/lib/openrgb/plugins/libOpenRGBVisualMapPlugin.so";
        force = true;
      };
    };
  };
}
