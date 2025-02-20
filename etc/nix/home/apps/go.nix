{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.go;
in
{
  options.den.apps.go.enable = mkEnableOption "golang";

  config = mkIf cfg.enable {

    programs.go = {
      enable = true;
      goPath = "opt/go";
    };

    home.sessionPath = [
      # go paths
      "${config.programs.go.goPath}/bin"
    ];

    programs.helix.languages = {
      language-server.gopls.command = "${pkgs.gopls}/bin/gopls";
      language = [
        {
          name = "go";
          auto-format = true;
          language-servers = [ "gopls" ];
          formatter.command = "${pkgs.gosimports}/bin/gosimports";
        }
      ];
    };
  };
}
