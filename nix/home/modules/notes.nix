{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.notes;
in
{
  options.den.notes = {
    enable = mkEnableOption "notes setup";

    path = mkOption {
      type = types.path;
      default = "${config.den.workspace.path}/notes";
    };

  };

  config = mkIf cfg.enable {
    home.sessionVariables.DEN_NOTES_DIR = cfg.path;
    den.shell.envVariables.DEN_NOTES_DIR = cfg.path;
  };
}
