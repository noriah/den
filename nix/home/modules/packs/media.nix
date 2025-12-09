{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.packs.media;
in
{
  options.den.packs.media = {
    enable = mkEnableOption "media pack";

    focusrite = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    den.apps.jamesdsp.enable = true;

    home.packages =
      with pkgs;
      [

        (pkgs.writeShellScriptBin "playerctl2" ''
          PLAYER=spotify
          ${pkgs.playerctl}/bin/playerctl -p "$PLAYER" "$@"
        '')

        # for pactl
        pulseaudio
        pwvucontrol
        qpwgraph

        vlc
        audacity

        rhythmbox

        # catnip
        catnip
      ]
      ++ (
        if cfg.focusrite then
          [
            alsa-scarlett-gui
          ]
        else
          [ ]
      );

    xdg.configFile."pipewire".source = "${config.den.dir.share}/pipewire";
    xdg.configFile."wireplumber".source = "${config.den.dir.share}/wireplumber";

  };
}
