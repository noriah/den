{ pkgs, ... }:

{
  openrgb = pkgs.callPackage ./openrgb.nix { };
  openrgb-plugin-effects = pkgs.callPackage ./openrgb-plugin-effects.nix { };
  openrgb-plugin-visual-map = pkgs.callPackage ./openrgb-plugin-visual-map.nix { };

  # to get jamesdsp 2.4
  pkgs_6ec9e25 = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "6ec9e2520787f319a6efd29cb67ed3e51237af7e";
    sha256 = "6dYqPSYhADkK37uiKW4GnwA/FtfYeb70fUuxSwONnoI=";
  }) { inherit (pkgs) system; };
}
