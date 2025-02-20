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
      default = "${config.den.dir.home}/.config";
    };

    dataHome = mkOption {
      type = types.path;
      default = "${config.den.dir.home}/var";
    };
  };

  config = mkIf cfg.enable {
    xdg.configHome = cfg.configHome;
    xdg.dataHome = cfg.dataHome;
    xdg.cacheHome = "${cfg.dataHome}/cache";
    xdg.stateHome = "${cfg.dataHome}/state";

    home.preferXdgDirectories = true;

    home.sessionVariables = {
      XDG_CONFIG_HOME = "${config.xdg.configHome}";
      XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
    };

    xdg.configFile."user-dirs.conf" = {
      text = "enabled=False\n";
      force = true;
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = false;

      desktop = "${config.den.dir.home}/desktop";
      download = "${config.den.dir.home}/downloads";
      documents = "${config.den.dir.home}/documents";
      pictures = "${config.den.dir.home}/pictures";
      music = "${config.den.dir.home}/music";
      videos = "${config.den.dir.home}/videos";

      templates = "${config.den.dir.home}/templates";

      publicShare = "${config.den.dir.home}/public";
    };

    xdg.dataFile.applications = {
      source = "${config.den.dir.share}/applications";
      recursive = true;
    };
  };
}
