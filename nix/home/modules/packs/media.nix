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
    enable = mkEnableOption "media module";

    focusrite = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    den.unfree = [
      "spotify"
    ];

    home.packages =
      with pkgs;
      [

        (pkgs.writeShellScriptBin "playerctl2" ''
          PLAYER=spotify
          ${pkgs.playerctl}/bin/playerctl -p "$PLAYER" "$@"
        '')

        # for pactl
        pulseaudio
        pkgs.pkgs_6ec9e25.jamesdsp
        pavucontrol
        qpwgraph

        spotify
        vlc
        audacity

        # catnip
        (buildGoModule rec {
          name = "catnip";
          version = "1.8.6";

          src = fetchFromGitHub {
            owner = "noriah";
            repo = "catnip";
            rev = "v${version}";
            sha256 = "sha256-oWin5PT/VZe9IAO3csMoHEn0GfdtBhntq5Db/2rFd0g=";
          };

          CGO_ENABLED = 0;

          vendorHash = "sha256-Hj453+5fhbUL6YMeupT5D6ydaEMe+ZQNgEYHtCUtTx4=";
        })
      ]
      ++ (
        if cfg.focusrite then
          [
            alsa-scarlett-gui
          ]
        else
          [ ]
      );

    systemd.user.services.jamesdsp = {
      Unit = {
        Description = "JamesDSP Audio Processor";
        After = "pipewire.service";
        BindsTo = "pipewire.service";
      };
      Install.WantedBy = [ "pipewire.service" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${pkgs.pkgs_6ec9e25.jamesdsp}/bin/jamesdsp --tray'';
        StandardError = "journal";
      };
    };

  };
}
