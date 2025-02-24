{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.vscode;
in
{
  options.den.apps.vscode = {
    enable = mkEnableOption "vscode";

    client = mkOption {
      type = types.bool;
      default = true;
    };

    server = mkOption {
      type = types.bool;
      default = false;
    };

    clientPackage = mkPackageOption pkgs "vscode" { };
  };

  config =
    mkIf (cfg.enable && cfg.client) {
      home.packages = [ cfg.clientPackage ];
      # link client config, keybindings, and snippets
    }
    // mkIf (cfg.enable && cfg.server) {
      # link server config
    };
}
