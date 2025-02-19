{
  config,
  pkgs,
  lib,
  ...
}:

let
  hostName = lib.removeSuffix "\n" (builtins.readFile /etc/hostname);
  hostModules = {
    "niji" = [ (import ./hosts/niji.nix) ];
  };

  den = pkgs.callPackage ./den.nix { };
in
{
  home.username = den.user;
  home.homeDirectory = den.homeDir;

  news.display = "silent";

  imports = [
    ./modules/shell.nix
    ./modules/development.nix
  ] ++ (hostModules.${hostName} or [ ]);

  home.packages = [ pkgs.file ];

  home.sessionPath = [
    "${config.programs.go.goPath}/bin"

    "${den.homeDir}/bin"
    "${den.homeDir}/rbin"
    "${den.homeDir}/opt/den/bin"
  ];

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
