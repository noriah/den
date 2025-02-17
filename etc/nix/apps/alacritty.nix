{ config, pkgs, ... }:
let
  den = pkgs.callPackage ../den.nix { };
in
{
  home.packages = [ pkgs.alacritty ];

  xdg.configFile.alacritty_config = {
    target = "alacritty";
    source = "${den.etcDir}/alacritty/default";
    force = true;
  };

  xdg.desktopEntries = {
    alacritty-visualizer = {
      type = "Application";
      settings.TryExec = "alacritty";
      exec = "alacritty --config-file ${config.xdg.configHome}/alacritty/visualizer.toml";
      icon = "Alacritty";
      terminal = false;
      categories = [
        "System"
        "TerminalEmulator"
      ];
      name = "Visualizer";
      genericName = "Terminal";
      comment = "Alacritty Visualizer Profile";
    };
  };
}
