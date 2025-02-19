{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.alacritty;
in
{
  options.den.apps.alacritty = {
    enable = mkEnableOption "alacritty terminal";
  };

  config = mkIf cfg.enable {

    home.packages = [ pkgs.alacritty ];

    xdg.configFile.alacritty_config = {
      target = "alacritty";
      source = "${config.den.etcDir}/alacritty/default";
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
  };
}
