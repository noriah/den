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

    home.packages = with pkgs; [
      nixd # nix lsp
      marksman # markdown lsp
      vscode-langservers-extracted
    ];

    programs.helix = {
      enable = true;

      settings = {
        theme = "monokai";
        editor.lsp.display-inlay-hints = true;
      };

      languages.language = [
        # nix
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nixd" ];
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
        # html
        {
          name = "html";
          language-servers = [ "vscode-html-language-server" ];
          formatter = {
            command = "prettier";
            args = [
              "--stdin-filepath"
              "file.html"
            ];
          };
          auto-format = true;
        }
        # json
        {
          name = "json";
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = [ "format" ];
            }
          ];
          auto-format = true;
        }
        # markdown
        {
          name = "markdown";
          language-servers = [ "marksman" ];
          formatter = {
            command = "prettier";
            args = [
              "--stdin-filepath"
              "file.md"
            ];
          };
          auto-format = true;
        }
      ];
    };

  };
}
