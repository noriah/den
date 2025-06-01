{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let

  cfg = config.den.apps.spotify;
in
{
  options.den.apps.spotify = {
    enable = mkEnableOption "spotify";

    xdg-open = mkOption {
      type = types.bool;
      default = true;
    };

  };

  config = mkIf cfg.enable {

    home.packages = [ pkgs.spotify ];

    den.unfree = [ "spotify" ];

    xdg.desktopEntries.spotify-open = mkIf cfg.xdg-open {
      type = "Application";
      name = "Open in Spotify";
      genericName = "Music Player";
      icon = "spotify-client";
      exec = "playerctl -p spotify open %U";
      terminal = false;
      mimeType = [
        "x-scheme-handler/spotify"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
      ];
      categories = [
        "Audio"
        "Music"
        "Player"
        "AudioVideo"
      ];
      settings = {
        StartupWMClass = "spotify";
      };
    };

  };
}
