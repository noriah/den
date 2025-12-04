{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.packs.xdg;

  # denCfg = config.den;
in
{

  options.den.packs.xdg = {
    enable = mkEnableOption "XDG pack";

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
      #XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
      XDG_STATE_HOME = cfg.stateHome;
    };
    #// mkIf denCfg.standalone {
    #  XDG_DATA_DIRS = "$HOME/.nix-profile/share:/usr/local/share/:/usr/share/:$XDG_DATA_DIRS";
    #};

    xdg.configFile."user-dirs.conf" = {
      text = "enabled=False\n";
      force = true;
    };

    # TODO(impermanence): include XDG user dirs in impermanence data

    xdg.userDirs = {
      enable = mkDefault true;
      createDirectories = mkDefault false;

      desktop = mkDefault "${cfg.userDirRoot}/desk";
      download = mkDefault "${cfg.userDirRoot}/dls";
      documents = mkDefault "${cfg.userDirRoot}/docs";
      pictures = mkDefault "${cfg.userDirRoot}/pics";
      music = mkDefault "${cfg.userDirRoot}/audio";
      videos = mkDefault "${cfg.userDirRoot}/vids";
      templates = mkDefault "${cfg.userDirRoot}/tmpls";
      publicShare = mkDefault "${cfg.userDirRoot}/pub";
    };

    xdg.dataFile.applications = {
      source = "${config.den.dir.share}/applications";
      recursive = true;
    };
  };
}
