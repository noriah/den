{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.modules.development;
in
{
  options.den.modules.development = {
    enable = mkEnableOption "development module";
  };

  config = mkIf cfg.enable {
    den.apps = {
      julia.enable = true;
      rust.enable = true;
    };

    home.packages = with pkgs; [
      python3
      julia
      # nixfmt
      nixfmt-rfc-style
      gcc
      gnumake
    ];

    home.sessionVariables = {
      EDITOR = "${config.den.editorBin}";

      # LD_LIBRARY_PATH = "${pkgs.gfortran.cc.lib}/lib:$LD_LIBRARY_PATH";

      # node stuff
      NPM_PATH = "${config.den.homeOptDir}/npm";
      NPM_CONFIG_CACHE = "${config.den.homeOptDir}/npm/cache";
    };

    home.sessionPath = [
      # node paths
      "./node_modules/.bin"

      # go paths
      "${config.programs.go.goPath}/bin"
    ];

    home.file.vimrc = {
      target = ".vimrc";
      source = "${config.den.etcDir}/vim/rc.vim";
      force = true;
    };

    programs.go = {
      enable = true;
      goPath = "opt/go";
    };

    programs.helix = {
      enable = true;
      settings = {
        theme = "monokai";
        editor.lsp.display-inlay-hints = true;
      };

      languages = {
        language-server.gopls.command = "${pkgs.gopls}/bin/gopls";
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          }
          {
            name = "go";
            auto-format = true;
            language-servers = [ "gopls" ];
            formatter.command = "${pkgs.gosimports}/bin/gosimports";
          }
        ];
      };
    };

  };
}
