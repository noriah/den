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

  pkgs = pkgs.callPackage ./packages { };
}
