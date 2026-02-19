{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.development.julia;
in
{
  options.den.development.julia = {

    enable = mkEnableOption "julia language";

    package = mkPackageOption pkgs "julia" { };

  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    den.shell.rcVariables = {
      JULIA_HISTORY = "$HISTORY/julia_repl_history.jl";
      JULIA_DEPOT_PATH = "${config.den.dir.opt}/julia";
    };

  };
}
