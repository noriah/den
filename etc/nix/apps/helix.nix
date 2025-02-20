{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.helix;
in
{
  options.den.apps.helix.enable = mkEnableOption "helix";

  config = mkIf cfg.enable {

    programs.helix = {
      enable = true;
      settings = {
        theme = "monokai";
        editor.lsp.display-inlay-hints = true;
      };

      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
      ];
    };
  };
}
