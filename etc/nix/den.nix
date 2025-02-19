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
  realHostName = lib.removeSuffix "\n" (builtins.readFile /etc/hostname);

  denDir = "${homeDir}/opt/den";

  cfg = config.den;

  hostName = if builtins.hasAttr "${realHostName}" cfg.hosts then realHostName else "unknown";
in
{
  options.den = {
    enable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "enable den";
    };

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

    editor = mkPackageOption pkgs "vim" { };

    editorBin = mkOption {
      type = types.path;
      default = "${cfg.editor}/bin/vim";
    };
  };

  config = mkIf cfg.enable {

    # enable some modules by default
    den.modules = {
      development.enable = true;
      shell.enable = true;
    };

    # enable our host configuration
    den.hosts.${cfg.hostName}.enable = true;

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

    home.file.den_user = {
      target = ".den/user";
      text = ''
        ${cfg.user}
      '';
      force = true;
    };

    home.file.den_hostname = {
      target = ".den/hostname";
      text = ''
        ${cfg.hostName}
      '';
      force = true;
    };

    home.file.profile = {
      target = ".profile";
      text = ''
        export XDG_CONFIG_HOME="${config.xdg.configHome}"
        export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
        source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      '';
      force = true;
    };
  };
}
