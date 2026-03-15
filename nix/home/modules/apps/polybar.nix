{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.polybar;
in
{
  options.den.apps.polybar = {

    enable = mkEnableOption "polybar";

    package = mkPackageOption pkgs "polybar" { };

  };

  config = mkIf cfg.enable {

    home.packages = [
      cfg.package

      pkgs.polyden
      pkgs.rocmPackages.amdsmi
    ];

    xdg.configFile = {

      polybar = {
        target = "polybar";
        source = "${config.den.dir.etc}/polybar/";
        recursive = true;
        # onChange = "${pkgs.systemd}/bin/systemctl --user restart polybar.target";
      };

      polybar-host = {
        target = "polybar/host.ini";
        source = "${config.den.dir.etc}/polybar/hosts/${config.den.hostName}.ini";
      };

    };

    systemd.user.targets.polybar = {
      Unit = {
        Description = "Polybar Target";
      };
      Install.WantedBy = [ "default.target" ];
    };

    systemd.user.services.polybar-primary-top = {
      Unit = {
        Description = "Polybar primary top";
        PartOf = "polybar.target";
      };
      Install.WantedBy = [ "polybar.target" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/polybar -r primary-top'';
        StandardError = "journal";
      };
    };

    systemd.user.services.polybar-primary-bottom = {
      Unit = {
        Description = "Polybar primary bottom";
        PartOf = "polybar.target";
      };
      Install.WantedBy = [ "polybar.target" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/polybar -r primary-bottom'';
        StandardError = "journal";
      };
    };

    systemd.user.services.polybar-secondary-top = {
      Unit = {
        Description = "Polybar secondary top";
        PartOf = "polybar.target";
      };
      Install.WantedBy = [ "polybar.target" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/polybar -r secondary-top'';
        StandardError = "journal";
      };
    };

    # systemd.user.services.polybar-secondary-bottom = {
    #   Unit = {
    #     Description = "Polybar secondary bottom";
    #     PartOf = "polybar.target";
    #   };
    #   Install.WantedBy = [ "polybar.target" ];
    #   Service = {
    #     Type = "simple";
    #     Restart = "on-failure";
    #     ExecStart = ''${cfg.package}/bin/polybar -r secondary-bottom'';
    #     StandardError = "journal";
    #   };
    # };

    # systemd.user.services.polybar-tertiary-top = {
    #   Unit = {
    #     Description = "Polybar tertiary top";
    #     PartOf = "polybar.target";
    #   };
    #   Install.WantedBy = [ "polybar.target" ];
    #   Service = {
    #     Type = "simple";
    #     Restart = "on-failure";
    #     ExecStart = ''${cfg.package}/bin/polybar -r tertiary-top'';
    #     StandardError = "journal";
    #   };
    # };

    # systemd.user.services.polybar-tertiary-bottom = {
    #   Unit = {
    #     Description = "Polybar tertiary bottom";
    #     PartOf = "polybar.target";
    #   };
    #   Install.WantedBy = [ "polybar.target" ];
    #   Service = {
    #     Type = "simple";
    #     Restart = "on-failure";
    #     ExecStart = ''${cfg.package}/bin/polybar -r tertiary-bottom'';
    #     StandardError = "journal";
    #   };
    # };

  };
}
