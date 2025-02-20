{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.workspace;
in
{
  options.den.workspace = {
    enable = mkEnableOption "workspaces";

    dirPath = mkOption {
      type = types.path;
      default = "${config.den.dir.home}/workspace";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.tmpfiles.rules = [
      "d ${cfg.dirPath} 0755 ${config.den.user} ${config.den.user}"
    ];

  };
}
