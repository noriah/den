{ pkgs, ... }:
let
  den = pkgs.callPackage ../den.nix { };
in
{

  home.packages = with pkgs; [
    tor
  ];

  home.file.torrc = {
    target = ".torrc";
    text = ''
      ClientOnly 1
      ControlPort 9051
      CookieAuthentication 1
      CookieAuthFile ${den.homeDir}/.tor/cookie-auth
      ExcludeExitNodes {ru},{cn},{uk},{gb},{us}
      #ExitNodes {nl},{de},{ca},{au}
      #ExitNodes {us}
      StrictNodes 1
      SocksPort localhost:9050
    '';
    force = true;
  };

}
