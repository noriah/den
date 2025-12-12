{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.tmux;
in
{
  options.den.apps.tmux.enable = mkEnableOption "tmux";

  config = mkIf cfg.enable {

    programs.tmux = {
      enable = true;
      terminal = "screen-256color";
      mouse = true;
      baseIndex = 1;

      extraConfig = ''
        set-option -g allow-rename on
        set-option -g set-titles on
        set-option -g set-titles-string "#W"
      '';
    };

    # tmux-config = {
    #   target = ".tmux.conf";
    #   source = "${config.den.dir.etc}/tmux/tmux.conf";
    #   force = true;
    # };

  };
}
