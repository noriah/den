{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.picom;
in
{
  options.den.apps.picom.enable = mkEnableOption "picom composter";

  config = mkIf cfg.enable {

    # home.packages = [ pkgs.picom ];

    services.picom = {
      enable = true;

      backend = "glx";
      vSync = true;

      shadow = false;
      shadowExclude = [
        "class_g = 'Polybar'"
        "class_g = 'polybar'"
        "class_g = 'i3-frame'"

        "name = 'Notification'"
        "class_g = 'Conky'"
        "class_g ?= 'Notify-osd'"
        "class_g = 'Cairo-clock'"
        "_GTK_FRAME_EXTENTS@:c"
      ];

      fade = false;

      activeOpacity = 1.0;
      inactiveOpacity = 1.0;

      wintypes = {
        tooltip = {
          fade = true;
          shadow = true;
          opacity = 1.0;
          focus = true;
          full-shadow = false;
        };
        dock = {
          shadow = false;
          clip-shadow-above = true;
        };
        dnd = {
          shadow = false;
        };
        popup_menu = {
          opacity = 1.0;
        };
        dropdown_menu = {
          opacity = 1.0;
        };
      };

      settings = {
        experimental-backends = true;
        inactive-opacity-override = false;

        frame-opacity = 1.0;

        focus-exclude = [
          "class_g = 'slop'" # maim
          "class_g = 'Cairo-clock'"
        ];

        rounded-corners-exclude = [
          "class_g = 'Alacritty'"
          "class_g = 'Polybar'"
          "class_g = 'polybar'"

          "window_type = 'dock'"
          "window_type = 'desktop'"
        ];

        blur-background = false;
        blur-kern = "3x3box";
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "_GTK_FRAME_EXTENTS@:c"
        ];

        dithered-present = false;

        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        glx-no-stencil = true;
        use-damage = true;
        log-level = "warn";
      };
    };
  };
}
