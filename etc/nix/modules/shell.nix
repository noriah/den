{ config, pkgs, ... }:
let
  den = pkgs.callPackage ../den.nix { };
in
{

  home.packages = with pkgs; [
    bat
    jq
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
      text = ". ${den.etcDir}/zsh/zshrc";
      force = true;
    };

    zshenv = {
      target = ".zshenv";
      text = ''
        . ${den.homeDir}/.profile
        . ${den.etcDir}/zsh/zshenv
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
      text = "SELECTED_EDITOR=\"${den.editorBin}\"\n";
      force = true;
    };

    tmux-config = {
      target = ".tmux.conf";
      source = "${den.etcDir}/tmux/tmux.conf";
      force = true;
    };
  };
}
