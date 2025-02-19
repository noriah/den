{ lib, pkgs, ... }:
let
  den = pkgs.callPackage ../den.nix { };
in
{
  den = {

    apps = {
      alacritty.enable = true;
      git.enable = true;
      gnome.enable = true;
      openrgb.enable = true;
      polybar.enable = true;
      tor.enable = true;
    };

    modules = {
      fonts.enable = true;
      xdg.enable = true;
      media.enable = true;
    };
  };

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
