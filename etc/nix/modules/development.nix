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
  options.den.modules.development.enable = mkEnableOption "development module";

  config = mkIf cfg.enable {
    den.apps = {
      helix.enable = true;
      git.enable = true;
      go.enable = true;
      julia.enable = true;
      rust.enable = true;
    };

    den.modules.shell.aliases = {
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
      EDITOR = "${config.den.editorBin}";

      # LD_LIBRARY_PATH = "${pkgs.gfortran.cc.lib}/lib:$LD_LIBRARY_PATH";

      # node stuff
      NPM_PATH = "${config.den.dir.opt}/npm";
      NPM_CONFIG_CACHE = "${config.den.dir.opt}/npm/cache";
    };

    home.sessionPath = [
      # node paths
      "./node_modules/.bin"
    ];

    home.file.vimrc = {
      target = ".vimrc";
      source = "${config.den.dir.etc}/vim/rc.vim";
      force = true;
    };
  };
}
