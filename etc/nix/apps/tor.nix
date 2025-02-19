{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.tor;
in
{
  options.den.apps.tor = {
    enable = mkEnableOption "tor";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      tor
    ];

    home.file.torrc = {
      target = ".torrc";
      text = ''
        ClientOnly 1
        ControlPort 9051
        CookieAuthentication 1
        CookieAuthFile ${config.den.homeDir}/.tor/cookie-auth
        ExcludeExitNodes {ru},{cn},{uk},{gb},{us}
        #ExitNodes {nl},{de},{ca},{au}
        #ExitNodes {us}
        StrictNodes 1
        SocksPort localhost:9050
      '';
      force = true;
    };

  };
}
