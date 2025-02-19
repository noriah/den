{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.git;
in
{
  options.den.apps.git = {
    enable = mkEnableOption "git vcs";
  };

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
        core.editor = config.den.editorBin;

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
          condition = "gitdir:~/opt/den/.git";
          path = "~/workspace/public/.gitconfig";
        }
        {
          condition = "gitdir:~/workspace/public/";
          path = "~/workspace/public/.gitconfig";
        }
        {
          condition = "gitdir:~/workspace/notes/";
          path = "~/workspace/public/.gitconfig";
        }
        {
          condition = "gitdir:~/workspace/phase/";
          path = "~/workspace/phase/.gitconfig";
        }
      ];
    };
  };
}
