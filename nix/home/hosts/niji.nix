{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  homeDir = "/home/vix";

  cfg = config.den.hosts.niji;
in
{
  options.den.hosts.niji = {
    enable = mkEnableOption "niji host";
  };

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
        albert.enable = true;
        gnome.enable = true;
        openrgb.enable = true;
        # polybar.enable = true;
        spotify.enable = true;
        tor.enable = true;

        syncthing.enable = true;

        vscode.enable = true;
        vscode.server = true;
      };

      notes = {
        enable = true;
        path = "${homeDir}/notes";
      };

      packs = {
        comfy.enable = true;
        development.enable = true;

        fonts.enable = true;
        fonts.installDenFonts = true;

        media.enable = true;
        media.focusrite = true;

        xdg.enable = true;
        xdg.userDirRoot = "${homeDir}/stuff";
      };

      shell.enable = true;

      workspace.enable = true;
      workspace.path = "${homeDir}/space";
    };

    home.packages = with pkgs; [
      zip
      wmctrl

      # installed globally
      # _1password-cli
      # _1password-gui

      # net util
      rdap
      socat

      # rtpmidi
      # clonehero

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

      r2modman

      rtpmidi
    ];

    den.unfree = [
      "google-chrome"
      "obsidian"
    ];

    programs.gpg.enable = true;
    services.gpg-agent.enable = true;

    systemd.user.startServices = "sd-switch";
  };
}
