{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.packs.development;
in
{
  options.den.packs.development = {
    enable = mkEnableOption "development module";

    gui = mkOption {
      type = types.bool;
      default = config.den.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    den.apps = mkMerge [
      {

        helix.enable = mkDefault true;
        git.enable = mkDefault true;
        vim.enable = mkDefault true;

        go.enable = mkDefault true;
        julia.enable = mkDefault true;
        rust.enable = mkDefault true;

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
      python3
      julia
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
