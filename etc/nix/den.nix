{
  # osConfig,
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
  # realHostName = osConfig.networking.hostName;
  # domain = osCOnfig.networking.domain;
  # fqdn = osCOnfig.networking.fqdn;

  denDir = "${homeDir}/opt/den";

  cfg = config.den;

  hostName = if builtins.hasAttr "${realHostName}" cfg.hosts then realHostName else "unknown";
in
{
  imports = [
    ./apps
    ./hosts
    ./modules
  ];

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

    hostName = mkOption {
      type = types.str;
      default = hostName;
    };

    dir = {
      self = mkOption {
        type = types.path;
        default = "${cfg.dir.opt}/den";
      };

      home = mkOption {
        type = types.path;
        default = homeDir;
      };

      etc = mkOption {
        type = types.path;
        default = "${cfg.dir.self}/etc";
      };

      share = mkOption {
        type = types.path;
        default = "${cfg.dir.self}/share";
      };

      opt = mkOption {
        type = types.path;
        default = "${cfg.dir.home}/opt";
      };

      var = mkOption {
        type = types.path;
        default = "${cfg.dir.home}/var";
      };
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
      shell = {
        enable = true;
        aliases = {
          hm = "home-manager";
        };
      };
    };

    # enable our host configuration
    den.hosts.${cfg.hostName}.enable = true;

    home.username = cfg.user;
    home.homeDirectory = cfg.dir.home;

    news.display = "silent";

    home.packages = with pkgs; [
      file
      curl
      wget
    ];

    home.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    home.sessionPath = [
      "${cfg.dir.self}/bin"
      "${cfg.dir.home}/bin"
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

    # home.file.den_domain = mkIf (domain != null) {
    #   target = ".den/domain";
    #   text = domain;
    #   force = true;
    # };

    home.file.profile = {
      target = ".profile";
      text = ''
        source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      '';
      force = true;
    };
  };
}
