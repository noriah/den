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
  };

  config = mkIf cfg.enable {
    # prefer XDG directories
    home.preferXdgDirectories = true;

    xdg.configHome = "${config.den.homeDir}/.config";
    xdg.dataHome = config.den.homeVarDir;
    xdg.cacheHome = "${config.den.homeVarDir}/cache";
    xdg.stateHome = "${config.den.homeVarDir}/state";

    xdg.configFile = {
      "user-dirs.conf".text = "enabled=False\n";
      "user-dirs.conf".force = true;
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

    xdg.dataFile = {
      applications = {
        target = "applications";
        source = "${config.den.shareDir}/applications";
        recursive = true;
      };
    };
  };
}
