{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  envVarsStr = config.lib.zsh.exportAll cfg.envVariables;

  aliasesStr =
    concatStringsSep "\n" (
      mapAttrsToList (k: v: "alias -- ${lib.escapeShellArg k}=${lib.escapeShellArg v}") cfg.aliases
    )
    + "\n";

  cfg = config.den.shell;
in
{
  options.den.shell = {
    enable = mkEnableOption "shell module";

    envVariables = mkOption {
      type = types.attrs;
      default = { };
    };

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bat
      jq
      neofetch
      tmux
    ];

    den.shell.envVariables = {
      HOME_ETC = config.den.dir.etc;
      HOME_OPT = config.den.dir.opt;
      HOME_SHARE = config.den.dir.share;
      HOME_VAR = config.den.dir.var;
    };

    home.shellAliases = {
      hm = "home-manager";
    };

    # programs.zsh.enable = true;

    home.file = {
      zshrc = {
        target = ".zshrc";
        text = ". ${config.den.dir.etc}/zsh/zshrc\n";
        force = true;
      };

      zshenv = {
        target = ".zshenv";
        text = ''
          . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"

          if [[ -z "$__DEN_SHELL_ENV_VARS_SOURCED" ]]; then
            export __DEN_SHELL_ENV_VARS_SOURCED=1
          ${envVarsStr}
          fi

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
        text = ''
          SELECTED_EDITOR="${config.den.editorBin}"
        '';
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
