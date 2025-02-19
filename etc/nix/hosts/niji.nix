{ lib, pkgs, ... }:
let
  den = pkgs.callPackage ../den.nix { };
in
{
  imports = [

    # apps

    ../apps/alacritty.nix
    ../apps/git.nix
    ../apps/gnome.nix
    ../apps/openrgb.nix
    ../apps/polybar.nix

    # modules

    ../modules/fonts.nix
    ../modules/media.nix
    ../modules/xdg.nix
  ];

  home.packages = with pkgs; [
    zip
    wmctrl

    # installed globally
    # _1password-cli
    # _1password-gui

    # net util
    rdap
    whois
    subnetcalc
    dnsutils
    nmap

    # hardware util
    ddcutil

    kitty

    # communication
    signal-desktop
    telegram-desktop

    # web
    google-chrome
    librewolf

    # info
    obsidian

    cheese
  ];

  services.syncthing.enable = true;

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  systemd.user.startServices = "sd-switch";
}
