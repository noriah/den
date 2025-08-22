{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let

  cfg = config.den.apps.irc-client;
in
{
  options.den.apps.irc-client = {
    enable = mkEnableOption "irc client";

    package = mkPackageOption pkgs "irssi" { };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

  };
}
