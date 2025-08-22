{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.dictionary;
in
{
  options.den.apps.dictionary = {
    enable = mkEnableOption "dictionary app";
  }

  config = mkIf cfg.enable {

    # home.packages = [ cfg.package ];

  };
}
