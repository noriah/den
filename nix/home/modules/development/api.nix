{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.development.go;
in
{
  options.den.development.api = {

    enable = mkEnableOption "api";


  };

  config = mkIf cfg.enable {

    home.packages = [ pkgs.insomnia ];

  };
}
