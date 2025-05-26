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

        spotify.enable = true;
        tor.enable = true;

        #vscode.enable = false;

        budgie.enable = true;

        syncthing.enable = true;

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

      shell.enable = true;

    };

    services.gnome-keyring.enable = true;

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

    den.unfree = [
      "obsidian"
    ];

    programs.gpg.enable = true;
    services.gpg-agent.enable = true;

    systemd.user.startServices = "sd-switch";
  };
}
