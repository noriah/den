{ pkgs, ... }:
let
  den = pkgs.callPackage ../den.nix { };
in
{
  home.packages = [
    pkgs.polybar

    # polyden
    (pkgs.buildGoModule rec {
      name = "polyden";
      version = "git";

      src =
        pkgs.fetchFromGitHub {
          owner = "noriah";
          repo = "den";
          rev = "f81db82e0acc584b7ece344493231f8a908dc2d7";
          sha256 = "Vbj5l1ofN6vZt9sGzXQMdEnSkZsUAZtGds90mGSMljM=";
        }
        + "/src/polyden";

      vendorHash = "sha256-QduatMLXBdpmwNuTNcGDNS6oe8kmL/wNOJrKXBhzj6A=";

    })
  ];

  xdg.configFile = {

    polybar = {
      target = "polybar";
      source = "${den.etcDir}/polybar/";
      recursive = true;
      # onChange = "${pkgs.systemd}/bin/systemctl --user restart polybar.target";
    };

    polybar-host = {
      target = "polybar/host.ini";
      source = "${den.etcDir}/polybar/hosts/${den.hostName}.ini";
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
  #     ExecStart = ''${pkgs.polybar}/bin/polybar -r main-top'';
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
      ExecStart = ''${pkgs.polybar}/bin/polybar -r main-bottom'';
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
      ExecStart = ''${pkgs.polybar}/bin/polybar -r left-top'';
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
      ExecStart = ''${pkgs.polybar}/bin/polybar -r left-bottom'';
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
      ExecStart = ''${pkgs.polybar}/bin/polybar -r right-top'';
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
      ExecStart = ''${pkgs.polybar}/bin/polybar -r right-bottom'';
      StandardError = "journal";
    };
  };
}
