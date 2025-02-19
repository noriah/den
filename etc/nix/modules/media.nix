{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  den_pkgs = pkgs.callPackage ../packages { };

  cfg = config.den.modules.media;
in
{
  options.den.modules.media = {
    enable = mkEnableOption "media module";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [

      (pkgs.writeShellScriptBin "playerctl2" ''
        PLAYER=spotify
        ${pkgs.playerctl}/bin/playerctl -p "$PLAYER" "$@"
      '')

      # for pactl
      pulseaudio
      den_pkgs.pkgs_6ec9e25.jamesdsp
      alsa-scarlett-gui
      pavucontrol
      qpwgraph

      spotify
      vlc

      catnip
      # (buildGoModule rec {
      #   name = "catnip";
      #   version = "git";

      #   src = fetchFromGitHub {
      #     owner = "noriah";
      #     repo = "catnip";
      #     rev = "9c9f6e035030a590947e72d0c58fe2182f2fee2f";
      #     sha256 = "9gneteQIzbMNjg/08uq+pCbs2a32He2gL+hovxcJFzE=";
      #   };

      #   CGO_ENABLED = 0;

      #   vendorHash = "sha256-Hj453+5fhbUL6YMeupT5D6ydaEMe+ZQNgEYHtCUtTx4=";
      # })
    ];

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
        ExecStart = ''${den_pkgs.pkgs_6ec9e25.jamesdsp}/bin/jamesdsp --tray'';
        StandardError = "journal";
      };
    };

  };
}
