{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  user = "vix";
  homeDir = builtins.getEnv "HOME";
  hostName = lib.removeSuffix "\n" (builtins.readFile /etc/hostname);

  denDir = "${homeDir}/opt/den";

  cfg = config.den;
in
{
  options.den = {
    user = mkOption {
      type = types.str;
    };

    homeDir = mkOption {
      type = types.path;
      default = homeDir;
    };

    hostName = mkOption {
      type = types.str;
      default = hostName;
    };

    dir = mkOption {
      type = types.path;
      default = "${cfg.homeDir}/opt/den";
    };

    etcDir = mkOption {
      type = types.path;
      default = "${cfg.dir}/etc";
    };

    shareDir = mkOption {
      type = types.path;
      default = "${cfg.dir}/share";
    };

    homeOptDir = mkOption {
      type = types.path;
      default = "${cfg.homeDir}/opt";
    };

    homeVarDir = mkOption {
      type = types.path;
      default = "${cfg.homeDir}/var";
    };

    homeConfDir = mkOption {
      type = types.path;
      default = "${cfg.homeDir}/.config";
    };

    editor = mkPackageOption pkgs "vim" { };

    editorBin = mkOption {
      type = types.path;
      default = "${cfg.editor}/bin/vim";
    };
  };

  config = {

    # enable some modules by default
    den.modules = {
      development.enable = true;
      shell.enable = true;
    };

    home.username = cfg.user;
    home.homeDirectory = cfg.homeDir;

    home.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    home.sessionPath = [
      "${cfg.dir}/bin"
      "${cfg.homeDir}/bin"
      "${cfg.homeDir}/rbin"
    ];
  };
}
