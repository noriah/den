{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let

  cfg = config.den.apps.microblogger;
in
{
  options.den.apps.microblogger = {
    enable = mkEnableOption "microblogger client";

    create-ssh-mount = mkOption {
      type = types.bool;
      default = true;
    };

    package = mkPackageOption pkgs "twtxt" { };
  };

  config = mkIf cfg.enable {

    home.packages = [
      cfg.package
      pkgs.sshfs
    ];

    systemd.user.mounts.home-vix-remote-log = mkIf cfg.create-ssh-mount {
      Unit = {
        Description = "twtxt-txt mount on svc0";
        Wants = [ "network-online.target" ];
        After = [ "network-online.target" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Mount = {
        What = "nor@svc0:/var/www/log-envy-run/";
        Where = "${config.den.dir.home}/remote/log";
        Type = "fuse.sshfs";
        Options = "x-systemd.automount,reconnect";
      };
    };

  };
}
