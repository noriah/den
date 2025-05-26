{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  gnome-enabled = config.den.apps.gnome.enable;

  cfg = config.den.apps.ulauncher;
in
{
  options.den.apps.ulauncher.enable = mkEnableOption "ulauncher";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.ulauncher ];

    dconf.settings =
      with lib.hm.gvariant;
      mkIf gnome-enabled {
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ulauncher/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ulauncher" = {
          binding = "<Super>space";
          command = "ulauncher-toggle";
          name = "ulauncher";
        };
      };
  };
}
