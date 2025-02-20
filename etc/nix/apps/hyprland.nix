{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.hyprland;
in
{
  options.den.apps.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = false;
    };
  };
}
