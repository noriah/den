{ lib, config, ... }:
with lib;
let
  notesEnabled = config.den.notes.enable;
  workspaceEnabled = config.den.workspace.enable;

  cfg = config.den.apps.git;
in
{
  options.den.apps.git.enable = mkEnableOption "git vcs";

  config = mkIf cfg.enable {

    programs.git = {
      enable = true;
      userName = "noriah";
      userEmail = "vix@noriah.dev";
      signing.key = "C6ACD7663C0FE39B";

      ignores = [
        ".DS_Store"
        "*.sublime-project"
        "*.sublime-workspace"
        "*.code-workspace"
      ];

      extraConfig = {
        core.editor = config.den.shell.editorBin;

        user.useConfigOnly = true;
        init.defaultBranch = "main";

        "filter \"lfs\"" = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };

      includes = [
        {
          condition = "gitdir:${config.den.dir.self}/.git";
          path = "${config.den.dir.etc}/git/public.gitconfig";
        }
        (mkIf notesEnabled {
          condition = "gitdir:${config.den.notes.path}/";
          path = "${config.den.dir.etc}/git/public.gitconfig";
        })
        (mkIf workspaceEnabled {
          condition = "gitdir:${config.den.workspace.path}/public/";
          path = "${config.den.dir.etc}/git/public.gitconfig";
        })
        (mkIf workspaceEnabled {
          condition = "gitdir:${config.den.workspace.path}/phase/";
          path = "${config.den.workspace.path}/phase/.gitconfig";
        })
      ];
    };

  };
}
