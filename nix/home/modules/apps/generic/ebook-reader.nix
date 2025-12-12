{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let

  cfg = config.den.apps.ebook-reader;
in
{
  options.den.apps.ebook-reader = {
    enable = mkEnableOption "ebook-reader";

    package = mkPackageOption pkgs "foliate" { };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

  };
}
