{ lib, pkgs, ... }:

let
  user = "vix";
  homeDir = builtins.getEnv "HOME";
  hostName = lib.removeSuffix "\n" (builtins.readFile /etc/hostname);

  denDir = "${homeDir}/opt/den";
in
{
  user = user;
  homeDir = homeDir;

  hostName = hostName;

  # den dir
  dir = denDir;
  etcDir = "${denDir}/etc";
  shareDir = "${denDir}/share";

  homeOptDir = "${homeDir}/opt";
  homeVarDir = "${homeDir}/var";
  homeConfDir = "${homeDir}/.config";

  editorBin = "${pkgs.vim}/bin/vim";

  pkgs = pkgs.callPackage ./packages { };

  # to get jamesdsp 2.4
  pkgs_6ec9e25 = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "6ec9e2520787f319a6efd29cb67ed3e51237af7e";
    sha256 = "6dYqPSYhADkK37uiKW4GnwA/FtfYeb70fUuxSwONnoI=";
  }) { inherit (pkgs) system; };
}
