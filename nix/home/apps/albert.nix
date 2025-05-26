{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  gnome-enabled = config.den.apps.gnome.enable;

  cfg = config.den.apps.albert;
in
{
  options.den.apps.albert.enable = mkEnableOption "albert";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.albert ];
    den.unfree = [ "albert" ];

    dconf.settings =
      with lib.hm.gvariant;
      mkIf gnome-enabled {
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/albert-toggle/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/albert-toggle" = {
          binding = "<Super>space";
          command = "albert toggle";
          name = "albert toggle";
        };
      };

    systemd.user.services.albert = {
      Unit.Description = "Albert Desk Bar";
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${pkgs.albert}/bin/albert'';
        StandardError = "journal";
      };
    };
  };
}
