{ pkgs, ... }:
let
  den = pkgs.callPackage ../den.nix { };
in
{

  # prefer XDG directories
  home.preferXdgDirectories = true;

  xdg.configHome = "${den.homeDir}/.config";
  xdg.dataHome = den.homeVarDir;
  xdg.cacheHome = "${den.homeVarDir}/cache";
  xdg.stateHome = "${den.homeVarDir}/state";

  xdg.configFile = {
    "user-dirs.conf".text = "enabled=False\n";
    "user-dirs.conf".force = true;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = false;

    desktop = "${den.homeDir}/desktop";
    download = "${den.homeDir}/downloads";
    documents = "${den.homeDir}/documents";
    pictures = "${den.homeDir}/pictures";
    music = "${den.homeDir}/music";
    videos = "${den.homeDir}/videos";

    templates = "${den.homeDir}/templates";

    publicShare = "${den.homeDir}/public";
  };

  xdg.dataFile = {
    applications = {
      target = "applications";
      source = "${den.shareDir}/applications";
      recursive = true;
    };
  };

}
