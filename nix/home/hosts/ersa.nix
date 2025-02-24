{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.hosts.ersa;
in
{
  options.den.hosts.ersa = {
    enable = mkEnableOption "ersa host";
  };

  config = mkIf cfg.enable {
    den = {

      gui.enable = true;

      apps = {
        alacritty.enable = true;
        i3.enable = true;
        openrgb.enable = true;
        picom.enable = true;
        polybar.enable = true;
        tor.enable = true;
      };

      packs = {
        comfy.enable = true;
        development.enable = true;
        fonts.enable = true;
        media.enable = true;

        xdg.enable = true;
      };
    };

    home.packages = with pkgs; [];

    services.syncthing.enable = true;

    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    systemd.user.startServices = "sd-switch";
  };
}
