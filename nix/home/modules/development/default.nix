{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.development;
in
{
  imports = [
    ./go.nix
    ./julia.nix
    ./python.nix
    ./rust.nix
  ];

  options.den.development = {
    enable = mkEnableOption "development module";

    gui = mkOption {
      type = types.bool;
      default = config.den.gui.enable;
    };

    all-languages.enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {

    den.development = {
      go.enable = mkDefault cfg.all-languages.enable;
      julia.enable = mkDefault cfg.all-languages.enable;
      rust.enable = mkDefault cfg.all-languages.enable;
      python.enable = mkDefault cfg.all-languages.enable;
    };

    den.apps = mkMerge [
      {
        helix.enable = mkDefault true;
        git.enable = mkDefault true;
        vim.enable = mkDefault true;
      }
      (mkIf cfg.gui {
        vscode.enable = mkDefault true;
        vscode.client = mkDefault true;
      })
    ];

    den.shell.aliases = {
      base16 = "xxd -c 0 -ps";
    };

    home.packages = with pkgs; [
      # nixfmt
      nixfmt-rfc-style
      gcc
      gnumake
      xxd
    ];

    home.sessionVariables = {
      # LD_LIBRARY_PATH = "${pkgs.gfortran.cc.lib}/lib:$LD_LIBRARY_PATH";

      # node stuff
      NPM_PATH = "${config.den.dir.opt}/npm";
      NPM_CONFIG_CACHE = "${config.den.dir.opt}/npm/cache";
    };

    home.sessionPath = [
      # node paths
      "./node_modules/.bin"
    ];

  };
}
