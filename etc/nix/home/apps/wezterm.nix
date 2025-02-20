{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.wezterm;
in
{
  options.den.apps.wezterm = {
    enable = mkEnableOption "wezterm terminal";

    package = mkPackageOption pkgs "wezterm" { };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    xdg.configFile.wezterm = {
      source = "${config.den.dir.etc}/wezterm";
      force = true;
    };

  };
}
