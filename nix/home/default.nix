{ outputs, lib, ... }:
{
  imports = [
    ./apps
    ./hosts
    ./modules
  ];

  nixpkgs.overlays = [
    outputs.overlays.new-packages
    outputs.overlays.modified-packages
    outputs.overlays.unstable-packages
  ];

  # root of den repo
  den.store = ../../.;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = lib.mkDefault "24.11"; # Please read the comment before changing.
}
