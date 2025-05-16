{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  subPath = "alacritty/default";
  visualizerConfig = "${config.den.dir.etc}/${subPath}/visualizer.toml";

  cfg = config.den.apps.alacritty;
in
{
  options.den.apps.alacritty.enable = mkEnableOption "alacritty terminal";

  config =
    mkIf cfg.enable {
      home.packages = [ pkgs.alacritty ];
    }
    // mkIf config.den.packs.xdg.enable {
      xdg.configFile.alacritty = {
        source = "${config.den.dir.etc}/${subPath}";
        force = true;
      };

      xdg.desktopEntries.alacritty-visualizer = {
        type = "Application";
        settings.TryExec = "alacritty";
        exec = "alacritty --config-file ${visualizerConfig}";
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
