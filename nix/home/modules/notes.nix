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

  # TODO(impermanence): include notes in user impermanence data

  config = mkIf cfg.enable {
    home.sessionVariables.DEN_NOTES_DIR = cfg.path;
  };
}
