{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.gnome;
in
{
  options.den.apps.gnome.enable = mkEnableOption "gnome desktop env";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      cheese
    ];

    gtk = {
      enable = true;
      theme.name = "Adwaita-dark";

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    dconf.settings = with lib.hm.gvariant; {

      "org/gnome/desktop/interface" = {
        accent-color = "pink";
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
      };

      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };

      "org/gnome/desktop/session" = {
        idle-delay = mkUint32 0;
      };

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

      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        overlay-key = "''";
        workspaces-only-on-primary = true;
      };

      "org/gnome/mutter/keybindings" = {
        switch-monitor = [ "XF86Display" ];
        toggle-tiled-left = [ ];
        toggle-tiled-right = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = [ "<Control><Super>q" ];
      };

      "org/gnome/shell" = {
        disabled-extensions = [
          "apps-menu@gnome-shell-extensions.gcampax.github.com"
          "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
          "window-list@gnome-shell-extensions.gcampax.github.com"
          "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "status-icons@gnome-shell-extensions.gcampax.github.com"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
          "dash-to-panel@jderose9.github.com"
          "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
          "mediacontrols@cliffniff.github.com"
        ];
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
        ];
        remember-mount-password = false;
      };

      "org/gnome/shell/app-switcher" = {
        current-workspace-only = false;
      };

      "org/gnome/shell/extensions/appindicator" = {
        tray-pos = "right";
      };

      # "org/gnome/shell/extensions/dash-to-panel" = {
      #   animate-appicon-hover = true;
      #   animate-appicon-hover-animation-type = "SIMPLE";
      #   appicon-margin = 4;
      #   appicon-padding = 4;
      #   appicon-style = "SYMBOLIC";
      #   dot-color-dominant = false;
      #   dot-color-override = false;
      #   dot-color-unfocused-different = false;
      #   dot-position = "BOTTOM";
      #   dot-size = 1;
      #   dot-style-focused = "METRO";
      #   dot-style-unfocused = "DASHES";
      #   focus-highlight = true;
      #   focus-highlight-dominant = false;
      #   focus-highlight-opacity = 25;
      #   group-apps = true;
      #   hotkeys-overlay-combo = "TEMPORARILY";
      #   intellihide = false;
      #   isolate-monitors = false;
      #   isolate-workspaces = false;
      #   leave-timeout = 50;
      #   leftbox-padding = -1;
      #   leftbox-size = 0;
      #   multi-monitors = false;
      #   panel-anchors = ''
      #     {"0":"MIDDLE"}
      #   '';
      #   panel-element-positions = ''
      #     {}
      #   '';
      #   panel-element-positions-monitors-sync = false;
      #   panel-lengths = ''
      #     {"0":91}
      #   '';
      #   panel-positions = ''
      #     {"0":"TOP"}
      #   '';
      #   panel-sizes = ''
      #     {"0":24}
      #   '';
      #   preview-custom-opacity = 50;
      #   preview-use-custom-opacity = true;
      #   primary-monitor = 0;
      #   scroll-icon-action = "CYCLE_WINDOWS";
      #   scroll-panel-action = "NOTHING";
      #   show-favorites = false;
      #   show-running-apps = true;
      #   show-showdesktop-hover = false;
      #   show-window-previews-timeout = 300;
      #   status-icon-padding = -1;
      #   trans-panel-opacity = 0.0;
      #   trans-use-custom-opacity = true;
      #   trans-use-dynamic-opacity = false;
      #   tray-padding = 6;
      #   window-preview-animation-time = 200;
      #   window-preview-hide-immediate-click = false;
      #   window-preview-title-position = "TOP";
      #   window-preview-use-custom-icon-size = false;
      # };

      "org/gnome/shell/extensions/mediacontrols" = {
        colored-player-icon = true;
        elements-order = [
          "ICON"
          "LABEL"
          "CONTROLS"
        ];
        extension-index = mkUint32 0;
        extension-position = "Center";
        fixed-label-width = true;
        label-width = mkUint32 200;
        labels-order = [
          " 🎵 "
          "TITLE"
          "-"
          "ARTIST"
        ];
        scroll-labels = true;
        show-control-icons-seek-backward = true;
        show-control-icons-seek-forward = true;
        show-player-icon = true;
      };

      "org/gnome/shell/extensions/workspace-indicator" = {
        embed-previews = false;
      };

      "org/gnome/shell/keybindings" = {
        shift-overview-down = [ "" ];
        shift-overview-up = [ "" ];
        toggle-overview = [ "<Super>c" ];
      };
    };
  };
}
