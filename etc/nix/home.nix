{
  config,
  pkgs,
  lib,
  ...
}:

let
  den = pkgs.callPackage ./den.nix { };
in
{
  home.username = den.user;
  home.homeDirectory = den.homeDir;

  news.display = "silent";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  imports = [

    # apps

    ./apps/alacritty.nix
    ./apps/git.nix
    ./apps/gnome.nix
    ./apps/openrgb.nix
    ./apps/polybar.nix

    # modules

    ./modules/audio.nix
    ./modules/development.nix
    ./modules/fonts.nix
    ./modules/shell.nix
    ./modules/xdg.nix
  ];

  home.packages = with pkgs; [
    # generic util
    file
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


    # random util
    neofetch

    # env/theme util
    # ulauncher

    # hardware util
    ddcutil

    kitty

    # dev util
    gnumake



    # communication
    signal-desktop
    telegram-desktop

    # web
    google-chrome
    librewolf

    # info
    obsidian

    # security
    nmap
    tor

    vlc


    catnip
    # (buildGoModule rec {
    #   name = "catnip";
    #   version = "git";

    #   src = fetchFromGitHub {
    #     owner = "noriah";
    #     repo = "catnip";
    #     rev = "9c9f6e035030a590947e72d0c58fe2182f2fee2f";
    #     sha256 = "9gneteQIzbMNjg/08uq+pCbs2a32He2gL+hovxcJFzE=";
    #   };

    #   CGO_ENABLED = 0;

    #   vendorHash = "sha256-Hj453+5fhbUL6YMeupT5D6ydaEMe+ZQNgEYHtCUtTx4=";
    # })
  ];

  home.file = {
    torrc = {
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
  };

  home.sessionPath = [
    "${config.programs.go.goPath}/bin"

    "${den.homeDir}/bin"
    "${den.homeDir}/rbin"
    "${den.homeDir}/opt/den/bin"
  ];

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  services.syncthing.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  systemd.user.startServices = "sd-switch";

}
