{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.budgie;
in
{
  options.den.apps.budgie.enable = mkEnableOption "budgie dm";

  config = mkIf cfg.enable {

    dconf.settings = with lib.hm.gvariant; {

      #"org/gnome/desktop/interface" = {
      #  accent-color = "pink";
      #  color-scheme = "prefer-dark";
      #  gtk-theme = "Adwaita-dark";
      #};

      #"org/gnome/desktop/peripherals/mouse" = {
      #  accel-profile = "flat";
      #};

      #"org/gnome/desktop/session" = {
      #  idle-delay = mkUint32 0;
      #};

      "org/gnome/desktop/wm/keybindings" = {
        activate-window-menu = [ "<Alt>space" ];
        close = [ "<Super>q" ];
        maximize = [ ];
        move-to-monitor-down = [ ];
        move-to-monitor-left = [ ];
        move-to-monitor-right = [ ];
        move-to-monitor-up = [ ];
        move-to-workspace-left = [ "<Super><Shift>Page_Up" ];
        move-to-workspace-right = [ "<Super><Shift>Page_Down" ];
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
        switch-to-workspace-left = [ "<Super>Page_Up" ];
        switch-to-workspace-right = [ "<Super>Page_Down" ];
        unmaximize = [ ];
      };

      "org/gnome/desktop/wm/preferences" = {
        mouse-button-modifier = "<Control><Super>";
        resize-with-right-button = true;
      };
    };
  };
}
