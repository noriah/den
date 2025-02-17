{
  lib,
  pkgs,
  ...
}:
let
  den = pkgs.callPackage ../den.nix { };
in
{
  home.packages = [
    den.pkgs.openrgb
    den.pkgs.openrgb-plugin-effects
    den.pkgs.openrgb-plugin-visual-map
  ];

  # nixpkgs.overlays = (pkgs.callPackage ../../nixos/openrgb.nix { }).nixpkgs.overlays;

  xdg.configFile = {
    openrgb-plugin-effects = {
      target = "OpenRGB/plugins/libOpenRGBEffectsPlugin.so";
      source = "${den.pkgs.openrgb-plugin-effects}/lib/openrgb/plugins/libOpenRGBEffectsPlugin.so";
      force = true;
    };

    openrgb-plugin-visual-map = {
      target = "OpenRGB/plugins/libOpenRGBVisualMapPlugin.so";
      source = "${den.pkgs.openrgb-plugin-visual-map}/lib/openrgb/plugins/libOpenRGBVisualMapPlugin.so";
      force = true;
    };
  };
}
