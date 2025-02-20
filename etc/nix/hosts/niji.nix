{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.hosts.niji;
in
{
  options.den.hosts.niji = {
    enable = mkEnableOption "niji host";
  };

  config = mkIf cfg.enable {
    den = {
      apps = {
        alacritty.enable = true;
        gnome.enable = true;
        openrgb.enable = true;
        polybar.enable = true;
        tor.enable = true;
      };

      modules = {
        comfy.enable = true;
        development.enable = true;
        fonts.enable = true;
        media.enable = true;
        xdg.enable = true;
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

      vscode

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
  };
}
