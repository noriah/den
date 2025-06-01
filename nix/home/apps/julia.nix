{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.julia;
in
{
  options.den.apps.julia = {

    enable = mkEnableOption "julia language";

    package = mkPackageOption pkgs "julia" { };

  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    home.sessionVariables = {
      JULIA_HISTORY = "$HISTORY/julia_repl_history.jl";
      JULIA_DEPOT_PATH = "${config.den.dir.opt}/julia";
    };

  };
}
