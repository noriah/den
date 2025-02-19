{
  lib,
  pkgs,
  config,
  ...
}:

let
  hostName = lib.removeSuffix "\n" (builtins.readFile /etc/hostname);
  hostModules = {
    "niji" = [ (import ./hosts/niji.nix) ];
  };
in
{
  imports = [
    ./den.nix
    ./apps
    ./modules
  ] ++ (hostModules.${hostName} or [ ]);

  den.user = "vix";

  news.display = "silent";

  home.packages = with pkgs; [
    file
    curl
    wget
  ];

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
