{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.modules.xdg;
in
{

  options.den.modules.xdg = {
    enable = mkEnableOption "XDG module";

    configHome = mkOption {
      type = types.path;
      default = "${config.den.homeDir}/.config";
    };

    dataHome = mkOption {
      type = types.path;
      default = "${config.den.homeDir}/var";
    };
  };

  config = mkIf cfg.enable {
    xdg.configHome = cfg.configHome;
    xdg.dataHome = cfg.dataHome;
    xdg.cacheHome = "${cfg.dataHome}/cache";
    xdg.stateHome = "${cfg.dataHome}/state";

    home.preferXdgDirectories = true;

    xdg.configFile."user-dirs.conf" = {
      text = "enabled=False\n";
      force = true;
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = false;

      desktop = "${config.den.homeDir}/desktop";
      download = "${config.den.homeDir}/downloads";
      documents = "${config.den.homeDir}/documents";
      pictures = "${config.den.homeDir}/pictures";
      music = "${config.den.homeDir}/music";
      videos = "${config.den.homeDir}/videos";

      templates = "${config.den.homeDir}/templates";

      publicShare = "${config.den.homeDir}/public";
    };

    xdg.dataFile.applications = {
      source = "${config.den.shareDir}/applications";
      recursive = true;
    };
  };
}
