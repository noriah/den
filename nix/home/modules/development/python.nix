{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.development.python;
in
{
  options.den.development.python = {

    enable = mkEnableOption "python language";

  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ python3 ];

    home.sessionVariables = {
      PYTHONSTARTUP = "${config.den.dir.share}/python/startup.py";
      PYTHON_HISTORY = "$HISTORY/python";
    };

  };
}
