{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.vim;
in
{
  options.den.apps.vim = {

    enable = mkEnableOption "vim";

    setDefaultEditor = mkOption {
      type = types.bool;
      default = true;
    };

    package = mkPackageOption pkgs "vim" { };

  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    home.file.".vimrc" = {
      source = "${config.den.dir.etc}/vim/rc.vim";
      force = true;
    };

    den.shell.editorBin = mkIf cfg.setDefaultEditor "${cfg.package}/bin/vim";

  };
}
