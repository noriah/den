{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  den_pkgs = pkgs.callPackage ../../packages { };

  cfg = config.den.hosts.poppy;
in
{
  options.den.hosts.poppy.enable = mkEnableOption "poppy host";

  config = mkIf cfg.enable {
    den = {
      dir.self = "${config.den.dir.home}/den";
      dir.opt = "${config.den.dir.home}/.opt";

      gui.enable = true;

      apps = {
        alacritty.enable = true;
        tor.enable = true;

        vscode.enable = false;

        go.goPath = ".opt/go";
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

    services.gnome-keyring.enable = true;

    home.packages = with pkgs; [
      zip

      gcr

      # net util
      rdap
      whois
      subnetcalc
      dnsutils
      nmap

      # communication
      signal-desktop
      telegram-desktop

      # web
      # google-chrome
      librewolf

      seahorse

      # info
      obsidian
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
