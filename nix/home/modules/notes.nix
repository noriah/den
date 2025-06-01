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

    obsidian.enable = mkEnableOption "obsidian notes";

  };

  # TODO(impermanence): include notes in user impermanence data

  config = mkIf cfg.enable (mkMerge [

    { home.sessionVariables.DEN_NOTES_DIR = cfg.path; }

    (mkIf cfg.obsidian.enable {
      home.packages = [ pkgs.obsidian ];
      den.unfree = [ "obsidian" ];
    })

  ]);
}
