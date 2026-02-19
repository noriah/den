{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  defaultNvmDir = "${config.den.dir.opt}/nvm";
  defaultNpmDir = "${config.den.dir.opt}/npm";
  defaultNpmCacheDir = "${config.den.dir.var}/cache/npm";

  cfg = config.den.development.node;
in
{
  options.den.development.node = {

    enable = mkEnableOption "node language";

    nvmDir = mkOption {
      type = types.str;
      default = defaultNvmDir;
    };

  };

  config = mkIf cfg.enable {

    den.shell.rcVariables = {
      NVM_DIR = "${cfg.nvmDir}";

      # node stuff
      NPM_PATH = "${defaultNpmDir}";
      NPM_CONFIG_CACHE = "${defaultNpmCacheDir}";
    };

    home.sessionPath = [
      # node paths
      "./node_modules/.bin"
    ];

  };
}
