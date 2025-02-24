{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.hosts.vyxn;
in
{
  options.den.hosts.vyxn = {
    enable = mkEnableOption "vyxn host";
  };

  config = mkIf cfg.enable {
    den = {
      apps = {
        alacritty.enable = true;
        tor.enable = true;
      };

      packs = {
        comfy.enable = true;
        development.enable = true;
      };
    };

    home.packages = with pkgs; [
      zip
      wmctrl

      # installed globally
      # _1password-cli
      # _1password-gui

      # net util
      rdap
      whois
      subnetcalc
      dnsutils
      nmap

      kitty

      vscode
    ];

    # services.syncthing.enable = true;

    # programs.gpg.enable = true;

    # services.gpg-agent = {
    #   enable = true;
    #   pinentryPackage = pkgs.pinentry-gnome3;
    # };
  };
}
