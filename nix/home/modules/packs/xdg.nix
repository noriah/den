{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.packs.xdg;
in
{

  options.den.packs.xdg = {
    enable = mkEnableOption "XDG module";

    userDirRoot = mkOption {
      type = types.path;
      default = config.den.dir.home;
    };

    configHome = mkOption {
      type = types.path;
      default = "${config.den.dir.home}/.config";
    };

    dataHome = mkOption {
      type = types.path;
      default = config.den.dir.var;
    };

    cacheHome = mkOption {
      type = types.path;
      default = "${cfg.dataHome}/cache";
    };

    stateHome = mkOption {
      type = types.path;
      default = "${cfg.dataHome}/state";
    };

  };

  config = mkIf cfg.enable {
    xdg.configHome = cfg.configHome;
    xdg.cacheHome = cfg.cacheHome;
    xdg.dataHome = cfg.dataHome;
    xdg.stateHome = cfg.stateHome;

    home.preferXdgDirectories = true;

    home.sessionVariables = {
      XDG_CONFIG_HOME = cfg.configHome;
      XDG_CACHE_HOME = cfg.cacheHome;
      XDG_DATA_HOME = cfg.dataHome;
      XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
      XDG_STATE_HOME = cfg.stateHome;
    };

    xdg.configFile."user-dirs.conf" = {
      text = "enabled=False\n";
      force = true;
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = false;

      desktop = "${cfg.userDirRoot}/desktop";
      download = "${cfg.userDirRoot}/downloads";
      documents = "${cfg.userDirRoot}/documents";
      pictures = "${cfg.userDirRoot}/pictures";
      music = "${cfg.userDirRoot}/music";
      videos = "${cfg.userDirRoot}/videos";

      templates = "${cfg.userDirRoot}/templates";

      publicShare = "${cfg.userDirRoot}/public";
    };

    xdg.dataFile.applications = {
      source = "${config.den.dir.share}/applications";
      recursive = true;
    };
  };
}
