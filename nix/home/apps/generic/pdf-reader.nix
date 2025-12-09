{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.pdf-reader;
in
{
  options.den.apps.pdf-reader = {
    enable = mkEnableOption "pdf-reader";

    package = mkPackageOption pkgs "evince" { };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

  };
}
