{ pkgs, ... }:

{
  openrgb = pkgs.callPackage ./openrgb.nix { };
  openrgb-plugin-effects = pkgs.callPackage ./openrgb-plugin-effects.nix { };
  openrgb-plugin-visual-map = pkgs.callPackage ./openrgb-plugin-visual-map.nix { };
}
