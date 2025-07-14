{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  homeDir = "/home/vix";

  cfg = config.den.hosts.niji;
in
{
  options.den.hosts.niji = {
    enable = mkEnableOption "niji host";
  };

  config = mkIf cfg.enable {
    den = {
      user = "vix";

      dir.home = homeDir;
      dir.self = "${homeDir}/den";
      dir.opt = "${homeDir}/.opt";

      gui.enable = true;

      apps = {
        _1password.enable = true;
        alacritty.enable = true;
        # albert.enable = true;
        # enable firefox custom config
        firefox.enable = true;
        gnome.enable = true;
        openrgb.enable = true;
        # polybar.enable = true;
        spotify.enable = true;
        tor.enable = true;

        syncthing.enable = true;

        vscode.enable = true;
        vscode.server = true;

        ebook-reader.enable = true;
        pdf-reader.enable = true;
      };

      notes = {
        enable = true;
        path = "${homeDir}/notes";
        obsidian.enable = true;
      };

      packs = {
        comfy.enable = true;
        development.enable = true;

        fonts.enable = true;
        fonts.installDenFonts = true;

        media.enable = true;
        media.focusrite = true;

        xdg.enable = true;
        xdg.userDirRoot = "${homeDir}/stuff";
      };

      shell.enable = true;

      workspace.enable = true;
      workspace.path = "${homeDir}/space";
    };

    home.packages = with pkgs; [
      zip
      wmctrl

      # installed globally
      # _1password-cli
      # _1password-gui

      # net util
      rdap

      ffmpeg-full

      lingot

      socat

      # rtpmidi
      # clonehero

      whois
      subnetcalc
      dnsutils
      nmap

      # hardware util
      ddcutil

      kitty

      # communication
      signal-desktop
      telegram-desktop

      # web
      google-chrome
      librewolf

      cheese

      r2modman

      wireshark

      rtpmidi

      lsp-plugins
    ];

    den.unfree = [
      "google-chrome"
    ];

    programs.gpg.enable = true;
    services.gpg-agent.enable = true;

    systemd.user.startServices = "sd-switch";

    # see https://wiki.libsdl.org/SDL2/FAQUsingSDL
    # home.sessionVariables.SDL_VIDEODRIVER = "wayland";
    # we use pipewire, but the pulseaudio driver gives best results in SDL games
    home.sessionVariables.SDL_AUDIODRIVER = "pulseaudio";
    home.sessionVariables.SDL_AUDIO_DRIVER = "pulseaudio";
  };
}
