{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  clientConfPath = "${config.xdg.configHome}/Code/User";
  serverConfPath = "${config.den.dir.home}/.vscode-server/data/Machine";
  srcPath = "${config.den.dir.self}/share/vscode";

  cfg = config.den.apps.vscode;
in
{
  options.den.apps.vscode = {

    enable = mkEnableOption "vscode";

    client = mkOption {
      type = types.bool;
      default = false;
    };

    clientPackage = mkPackageOption pkgs "vscode" { };

    server = mkOption {
      type = types.bool;
      default = false;
    };

  };

  config = mkIf cfg.enable (mkMerge [

    (mkIf cfg.client {
      den.unfree = [ "vscode" ];

      home.packages = [ cfg.clientPackage ];

      systemd.user.tmpfiles.rules = [
        "L+ ${clientConfPath}/settings.json - - - - ${srcPath}/settings/client.niji.json"
        "L+ ${clientConfPath}/keybindings.json - - - - ${srcPath}/settings/keybindings.linux.json"
        "L+ ${clientConfPath}/snippets - - - - ${srcPath}/snippets"
      ];
    })

    (mkIf cfg.server {
      systemd.user.tmpfiles.rules = [
        "L+ ${serverConfPath}/settings.json - - - - ${srcPath}/settings/server.json"
      ];
    })

  ]);
}
