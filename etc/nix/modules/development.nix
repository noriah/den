{ lib, pkgs, ... }:
let
  den = pkgs.callPackage ../den.nix { };
in
{
  home.packages = with pkgs; [

    # coding
    vscode
    go
    python3
    rust-analyzer
    julia
    # nixfmt
    nixfmt-rfc-style

    gcc

    gnumake
  ];

  home.sessionVariables = {
    EDITOR = den.editorBin;

    # LD_LIBRARY_PATH = "${pkgs.gfortran.cc.lib}/lib:$LD_LIBRARY_PATH";

    # rust stuff
    RUSTUP_HOME = "${den.homeOptDir}/rustup";
    CARGO_HOME = "${den.homeOptDir}/cargo";

    # julia stuff
    # JULIA_HISTORY = "$HISTORY/julia_repl_history.jl";
    JULIA_DEPOT_PATH = "${den.homeOptDir}/julia";

    # node stuff
    NPM_PATH = "${den.homeOptDir}/npm";
    NPM_CONFIG_CACHE = "${den.homeOptDir}/npm/cache";
  };

  home.sessionPath = [
    # node paths
    "./node_modules/.bin"
  ];

  home.file.vimrc = {
    target = ".vimrc";
    source = "${den.etcDir}/vim/rc.vim";
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
      language-server.rustls.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
        {
          name = "rust";
          auto-format = false;
          language-servers = [ "rustls" ];
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

}
