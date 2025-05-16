{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  sockPath = "${config.den.dir.home}/.1password/agent.sock";

  cfg = config.den.apps._1password;
in
{
  options.den.apps._1password.enable = mkEnableOption "1password";

  config = mkIf cfg.enable {
    home.sessionVariables.SSH_HOST_SOCK = sockPath;
  };
}
