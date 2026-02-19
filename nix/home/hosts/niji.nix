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
      dir.opt = "${homeDir}/opt";

      gui.enable = true;

      apps = {
        # desktop environment
        # this should be a select, maybe
        budgie.enable = true;

        _1password.enable = true;

        alacritty.enable = true;

        firefox.enable = true; # enable firefox custom config

        openrgb.enable = true;

        # spotify.enable = true;
        tor.enable = true;

        syncthing.enable = true;

        polybar.enable = true;

        vscode.enable = true;
        vscode.server = true;

        ebook-reader.enable = true;
        irc-client.enable = true;
        #microblogger.enable = true;
        pdf-reader.enable = true;
        screenshot.enable = true;
        terminal.enable = true;
      };

      notes = {
        enable = true;
        path = "${homeDir}/notes";
        obsidian.enable = true;
      };

      xdg = {
        enable = true;
        userDirRoot = "${homeDir}/stuff";
      };

      development.enable = true;

      packs = {
        comfy.enable = true;

        fonts.enable = true;
        fonts.installDenFonts = true;

        media.enable = true;
        media.focusrite = true;
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

      mumble

      # hardware util
      ddcutil

      mediainfo

      # kitty

      ksnip

      # communication
      signal-desktop
      # telegram-desktop

      # web
      google-chrome
      librewolf

      cheese

      # r2modman

      wireshark

      rtpmidi

      # lsp-plugins
      vcv-rack-pro

      (wrapOBS {
        plugins = with obs-studio-plugins; [
          distroav
        ];
      })
    ];

    den.unfree = [
      "google-chrome"
      "ndi-6"
      "castlabs-electron"
      # "vcv-rack"
    ];

    systemd.user.services.set-default-audio = {
      Unit = {
        Description = "Set default audio";
        After = "wireplumber.service";
        BindsTo = "wireplumber.service";
      };
      Install.WantedBy = [ "wireplumber.service" ];
      Service = {
        Type = "oneshot";
        ExecStart = ''${config.den.store}/bin/set-default-audio-devices-niji.sh'';
        StandardError = "journal";
      };
    };

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
