{
  # osConfig,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.den;
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
      type = types.nonEmptyStr;
    };

    hostName = mkOption {
      type = types.str;
      default = hostName;
    };

    store = mkOption {
      type = types.path;
    };

    standalone = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "standalone home manager without NixOS";
    };

    dir = {
      self = mkOption {
        type = types.path;
        default = "${cfg.dir.opt}/den";
      };

      home = mkOption {
        type = types.path;
      };

      etc = mkOption {
        type = types.path;
        default = "${cfg.store}/etc";
      };

      share = mkOption {
        type = types.path;
        default = "${cfg.store}/share";
      };

      opt = mkOption {
        type = types.path;
        default = "${cfg.dir.home}/.opt";
      };

      var = mkOption {
        type = types.path;
        default = "${cfg.dir.home}/var";
      };
    };

    unfree = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "A list of unfree packages that are allowed to be installed";
    };

    insecure = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "A list of insecure packages that are allowed to be installed";
    };
  };

  config = mkIf cfg.enable {

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) cfg.unfree;
    nixpkgs.config.permittedInsecurePackages = cfg.insecure;

    news.display = "silent";

    den.shell.aliases.hm = mkDefault "home-manager --flake ${cfg.dir.self}";
    den.shell.aliases.nosrb = mkDefault "sudo nixos-rebuild --flake ${cfg.dir.self}";

    # enable our host configuration
    den.hosts.${cfg.hostName}.enable = mkDefault true;

    home.username = cfg.user;
    home.homeDirectory = cfg.dir.home;

    home.packages = with pkgs; [
      file
      curl
      wget
    ];

    home.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      HOME_ETC = cfg.dir.etc;
      HOME_SHARE = cfg.dir.share;
      HOME_OPT = cfg.dir.opt;
      HOME_VAR = cfg.dir.var;
      LC_ALL = "C.UTF-8";
      LANG = "en_US";
      LANGUAGE = "en_US";
    };

    home.sessionPath = [
      "${cfg.dir.self}/bin"
      "${cfg.dir.home}/rbin"
    ];

    home.file.den_user = {
      target = ".den/user";
      text = cfg.user;
      force = true;
    };

    home.file.den_hostname = {
      target = ".den/hostname";
      text = cfg.hostName;
      force = true;
    };

    systemd.user.tmpfiles.rules = [
      "L+ ${config.den.dir.home}/tmp - - - - /run/user/1000"
    ];

    # home.file.den_domain = mkIf (domain != null) {
    #   target = ".den/domain";
    #   text = domain;
    #   force = true;
    # };

    home.file.profile = {
      target = ".profile";
      text = ''
        . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
      '';
      force = true;
    };

  };
}
