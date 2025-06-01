{ lib, config, ... }:
with lib;
let
  cfg = config.den.packs.wayland;
in
{
  options.den.packs.wayland.enable = mkEnableOption "wayland pack";

  config = mkIf cfg.enable { };
}
