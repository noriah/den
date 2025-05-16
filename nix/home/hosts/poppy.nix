{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  homeDir = "/home/vix";

  cfg = config.den.hosts.poppy;
in
{
  options.den.hosts.poppy.enable = mkEnableOption "poppy host";

  config = mkIf cfg.enable {
    den = {
      user = "vix";

      dir.home = homeDir;
      dir.self = "${homeDir}/den";
      dir.opt = "${homeDir}/.opt";

      gui.enable = true;

      apps = {
        _1password.enable = true;
        alacritty.enable = true;
        tor.enable = true;

        #vscode.enable = false;

        budgie.enable = true;

      };

      notes = {
        enable = true;
        path = "${homeDir}/notes";
      };

      packs = {
        comfy.enable = true;
        development.enable = true;

        fonts.enable = true;
        media.enable = true;

        xdg.enable = true;
        xdg.userDirRoot = "${homeDir}/stuff";
      };

      workspace = {
        enable = true;
        path = "${homeDir}/space";
      };

    };

    services.gnome-keyring.enable = true;

    den.unfree = [
      "obsidian"
    ];

    home.packages = with pkgs; [
      zip

      gcr

      mosh

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

      beneath-a-steel-sky

      seahorse

      # info
      obsidian

      virt-viewer

      incus
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
