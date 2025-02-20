{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.modules.shell;

  aliasesStr =
    concatStringsSep "\n" (
      mapAttrsToList (k: v: "alias -- ${lib.escapeShellArg k}=${lib.escapeShellArg v}") cfg.aliases
    )
    + "\n";
in
{
  options.den.modules.shell = {
    enable = mkEnableOption "shell module";

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = literalExpression ''
        {
          g = "git";
          "..." = "cd ../..";
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bat
      jq
      neofetch
    ];

    home.shellAliases = {
      hm = "home-manager";
    };

    # programs.zsh.enable = true;

    home.file = {
      zshrc = {
        target = ".zshrc";
        text = ". ${config.den.dir.etc}/zsh/zshrc";
        force = true;
      };

      zshenv = {
        target = ".zshenv";
        text = ''
          . ${config.den.dir.home}/.profile
          . ${config.den.dir.etc}/zsh/zshenv
        '';
        force = true;
      };

      zaliases = mkIf (aliasesStr != "\n") {
        target = ".zaliases";
        text = aliasesStr;
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
        source = "${config.den.dir.etc}/tmux/tmux.conf";
        force = true;
      };
    };
  };
}
