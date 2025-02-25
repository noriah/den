{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  den_pkgs = pkgs.callPackage ../../packages { };

  cfg = config.den.hosts.plix;
in
{
  options.den.hosts.plix.enable = mkEnableOption "plix host";

  config = mkIf cfg.enable {
    den = {
      dir.self = "${config.den.dir.home}/den";
      dir.opt = "${config.den.dir.home}/.opt";

      gui.enable = true;

      apps = {
        alacritty.enable = true;
        tor.enable = true;

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

    home.packages = with pkgs; [
      zip

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
