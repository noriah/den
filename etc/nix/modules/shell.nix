{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.modules.shell;
in
{
  options.den.modules.shell = {
    enable = mkEnableOption "shell module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bat
      jq
      neofetch
    ];

    home.file = {
      profile = {
        target = ".profile";
        text = ''
          export XDG_CONFIG_HOME="${config.xdg.configHome}";
          export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
          source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        '';
        force = true;
      };

      zshrc = {
        target = ".zshrc";
        text = ". ${config.den.etcDir}/zsh/zshrc";
        force = true;
      };

      zshenv = {
        target = ".zshenv";
        text = ''
          . ${config.den.homeDir}/.profile
          . ${config.den.etcDir}/zsh/zshenv
        '';
        force = true;
      };

      hushlogin = {
        target = ".hushlogin";
        text = "\n";
        force = true;
      };

      selected-editor = {
        target = ".selected_editor";
        text = "SELECTED_EDITOR=\"${config.den.editorBin}\"\n";
        force = true;
      };

      tmux-config = {
        target = ".tmux.conf";
        source = "${config.den.etcDir}/tmux/tmux.conf";
        force = true;
      };
    };
  };
}
