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

    services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

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
        move-to-workspace-1 = [ ];
        move-to-workspace-last = [ ];
        move-to-workspace-left = [ "<Super><Shift>Home" ];
        move-to-workspace-right = [ "<Super><Shift>End" ];
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
        switch-to-workspace-1 = [ ];
        switch-to-workspace-first = [ ];
        switch-to-workspace-last = [ ];
        switch-to-workspace-left = [ "<Super>Home" ];
        switch-to-workspace-right = [ "<Super>End" ];
        unmaximize = [ ];
      };

      "org/gnome/desktop/wm/preferences" = {
        mouse-button-modifier = "<Control><Super>";
        resize-with-right-button = true;
      };

      "org/gnome/mutter/wayland/keybindings" = {
        restore-shortcuts = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        help = [ ];
        screensaver = [ "<Primary><Super>q" ];
      };
    };
  };
}
