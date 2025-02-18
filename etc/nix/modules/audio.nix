{ lib, pkgs, ... }:
let
  den = pkgs.callPackage ../den.nix { };
in
{
  home.packages = with pkgs; [

    (pkgs.writeShellScriptBin "playerctl2" ''
      PLAYER=spotify
      ${pkgs.playerctl}/bin/playerctl -p "$PLAYER" "$@"
    '')

    den.pkgs_6ec9e25.jamesdsp

    alsa-scarlett-gui
    pavucontrol

    qpwgraph
    spotify

    # for pactl
    pulseaudio
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
      ExecStart = ''${den.pkgs_6ec9e25.jamesdsp}/bin/jamesdsp --tray'';
      StandardError = "journal";
    };
  };

}
