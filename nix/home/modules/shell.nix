{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  rcVarsStr = (config.lib.zsh.exportAll cfg.rcVariables) { };

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

    rcVariables = mkOption {
      type = types.attrs;
      default = { };
    };

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };

    editorBin = mkOption {
      type = types.path;
      default = null;
    };

  };

  config = mkIf cfg.enable (mkMerge [

    {
      den.apps = {
        tmux.enable = mkDefault true;
        vim.enable = mkDefault true;
      };

      home.packages = with pkgs; [
        bat
        jq
      ];

      # programs.zsh.enable = true;

      home.file = {
        zshrc = {
          target = ".zshrc";
          text = ''
            if [[ -z "$__DEN_SHELL_RC_VARS_SOURCED" ]]; then
            export __DEN_SHELL_RC_VARS_SOURCED=1
            ${rcVarsStr}
            fi

            . "${config.den.dir.etc}/zsh/zshrc"
            unsetopt sharehistory
          '';
          force = true;
        };

        zshenv = {
          target = ".zshenv";
          text = ''
            . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
            . "${config.den.dir.home}/.den/env"
            . "${config.den.dir.etc}/zsh/zshenv"
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

      };

      # TODO: replace user ID with system user ID when we can access osConfig
      # userId = config.users.users.${config.den.user}.uid
      # /run/user/${userId}
      systemd.user.tmpfiles.rules = [
        "L+ ${config.den.dir.home}/tmp - - - - /run/user/1000"
      ];
    }

    (mkIf (!isNull cfg.editorBin) {
      home.sessionVariables.EDITOR = cfg.editorBin;

      home.file.".selected_editor" = {
        text = ''
          SELECTED_EDITOR="${cfg.editorBin}"
        '';
        force = true;
      };
    })

  ]);
}
