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

      # polyden
      (pkgs.buildGoModule rec {
        name = "polyden";
        version = "git";

        src =
          pkgs.fetchFromGitHub {
            owner = "noriah";
            repo = "den";
            rev = "c17e9f1fcb2fe2786fc2b1863f17d69facc7d1f9";
            sha256 = "o22KMEGpcd8MkqC0CD/s8rgPehR3+n9onjV3GFxh/7E=";
          }
          + "/src/polyden";

        vendorHash = "sha256-QduatMLXBdpmwNuTNcGDNS6oe8kmL/wNOJrKXBhzj6A=";

      })
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
      Install.WantedBy = [ "graphical-session.target" ];
    };

    # systemd.user.services.polybar-main-top = {
    #   Unit = {
    #     Description = "Polybar main top";
    #     PartOf = "polybar.target";
    #   };
    #   Install.WantedBy = [ "polybar.target" ];
    #   Service = {
    #     Type = "simple";
    #     Restart = "on-failure";
    #     ExecStart = ''${cfg.package}/bin/polybar -r main-top'';
    #     StandardError = "journal";
    #   };
    # };

    systemd.user.services.polybar-main-bottom = {
      Unit = {
        Description = "Polybar main bottom";
        PartOf = "polybar.target";
      };
      Install.WantedBy = [ "polybar.target" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/polybar -r main-bottom'';
        StandardError = "journal";
      };
    };

    systemd.user.services.polybar-left-top = {
      Unit = {
        Description = "Polybar left top";
        PartOf = "polybar.target";
      };
      Install.WantedBy = [ "polybar.target" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/polybar -r left-top'';
        StandardError = "journal";
      };
    };

    systemd.user.services.polybar-left-bottom = {
      Unit = {
        Description = "Polybar left bottom";
        PartOf = "polybar.target";
      };
      Install.WantedBy = [ "polybar.target" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/polybar -r left-bottom'';
        StandardError = "journal";
      };
    };

    systemd.user.services.polybar-right-top = {
      Unit = {
        Description = "Polybar right top";
        PartOf = "polybar.target";
      };
      Install.WantedBy = [ "polybar.target" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/polybar -r right-top'';
        StandardError = "journal";
      };
    };

    systemd.user.services.polybar-right-bottom = {
      Unit = {
        Description = "Polybar right bottom";
        PartOf = "polybar.target";
      };
      Install.WantedBy = [ "polybar.target" ];
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/polybar -r right-bottom'';
        StandardError = "journal";
      };
    };
  };
}
