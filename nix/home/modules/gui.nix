{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.gui;
in
{
  options.den.gui = {
    enable = mkEnableOption "gui environment components";
  };

  config = mkIf cfg.enable {};
}
