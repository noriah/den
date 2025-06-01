{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  # https://github.com/nix-community/home-manager/blob/release-24.11/modules/programs/go.nix#L41
  goFullPath = "${config.home.homeDirectory}/${config.programs.go.goPath}";
  cfg = config.den.apps.go;
in
{
  options.den.apps.go = {

    enable = mkEnableOption "golang";

    goPath = mkOption {
      type = types.str;
      default = "${config.den.dir.opt}/go";
    };

  };

  config = mkIf cfg.enable {

    programs.go = {
      enable = mkDefault true;
      goPath = mkDefault cfg.goPath;
    };

    home.sessionPath = [ "${goFullPath}/bin" ];

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
