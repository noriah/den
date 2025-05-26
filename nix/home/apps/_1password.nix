{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  sockPath = "${config.den.dir.home}/.1password/agent.sock";

  gnome-enabled = config.den.apps.gnome.enable;

  cfg = config.den.apps._1password;
in
{
  options.den.apps._1password.enable = mkEnableOption "1password";

  config = mkIf cfg.enable {
    home.sessionVariables.SSH_HOST_SOCK = sockPath;

    den.unfree = [ "1password" ];

    dconf.settings =
      with lib.hm.gvariant;
      mkIf gnome-enabled {
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password" = {
          binding = "<Shift><Control>space";
          command = "1password --quick-access";
          name = "1password quick-access";
        };
      };

    systemd.user.services."1password" = {
      Unit = {
        Description = "1Pass password manager";
        After = "dbus.service";
        BindsTo = "dbus.service";
      };
      Install.WantedBy = [ "dbus.service" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${pkgs._1password-gui}/bin/1password --silent'';
        StandardError = "journal";
      };
    };
  };
}
