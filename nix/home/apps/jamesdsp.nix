{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.jamesdsp;
in
{
  options.den.apps.jamesdsp = {

    enable = mkEnableOption "jamesdsp terminal";

    package = mkPackageOption pkgs.pkgs_6ec9e25 "jamesdsp" { };

    systemdService = mkOption {
      type = types.bool;
      default = true;
    };

  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    systemd.user.services.jamesdsp = mkIf cfg.systemdService {
      Unit = {
        Description = "JamesDSP Audio Processor";
        After = "pipewire.service";
        BindsTo = "pipewire.service";
      };
      Install.WantedBy = [ "pipewire.service" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/jamesdsp --tray'';
        StandardError = "journal";
      };
    };

  };
}
