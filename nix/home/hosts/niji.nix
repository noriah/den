{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  den_pkgs = pkgs.callPackage ../../packages { };

  cfg = config.den.hosts.niji;
in
{
  options.den.hosts.niji = {
    enable = mkEnableOption "niji host";
  };

  config = mkIf cfg.enable {
    den = {
      dir.self = "${config.den.dir.home}/den";
      dir.opt = "${config.den.dir.home}/.opt";

      gui.enable = true;

      apps = {
        alacritty.enable = true;
        gnome.enable = true;
        openrgb.enable = true;
        polybar.enable = true;
        tor.enable = true;

        go.goPath = ".opt/go";

        vscode.enable = true;
        vscode.server = true;
      };

      packs = {
        comfy.enable = true;
        development.enable = true;

        fonts.enable = true;
        media.enable = true;

        xdg.enable = true;
        xdg.userDirRoot = "${config.den.dir.home}/stuff";
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

      den_pkgs.r2modman
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
