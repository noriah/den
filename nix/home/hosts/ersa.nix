{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  homeDir = "/home/vix";
  cfg = config.den.hosts.ersa;
in
{
  options.den.hosts.ersa = {
    enable = mkEnableOption "ersa host";
  };

  config = mkIf cfg.enable {
    den = {
      user = "nor";

      dir.home = homeDir;

      gui.enable = true;

      apps = {
        alacritty.enable = true;
        i3.enable = true;
        picom.enable = true;
        polybar.enable = true;
        spotify.enable = true;
        tor.enable = true;
      };

      packs = {
        comfy.enable = true;
        development.enable = true;
        fonts.enable = true;
        media.enable = true;

        xdg.enable = true;
      };

      shell.enable = true;
    };

    home.packages = with pkgs; [ ];

    services.syncthing.enable = true;

    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    systemd.user.startServices = "sd-switch";
  };
}
