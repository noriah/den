{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.hosts.unknown;
in
{
  options.den.hosts.unknown = {
    enable = mkEnableOption "unknown host";
  };

  config = mkIf cfg.enable {
    den.modules = {
      comfy.enable = true;
    };

    den.apps = {
      git.enable = true;
    };

    # unknown hosts may be uncontrolled hosts
    # disable check for compatibility
    home.enableNixpkgsReleaseCheck = false;

    home.packages = with pkgs; [
      zip
      rdap
      whois
      subnetcalc
      dnsutils
      nmap
    ];
  };
}
