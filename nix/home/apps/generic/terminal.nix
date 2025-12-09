{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.terminal;
in
{
  options.den.apps.terminal = {
    enable = mkEnableOption "terminal";

    package = mkPackageOption pkgs "alacritty" { };
    backupTerminalPackage = mkPackageOption pkgs "st" { };
  };

  config = mkIf cfg.enable {

    home.packages = [
      cfg.package
      cfg.backupTerminalPackage
    ];
  };
}
