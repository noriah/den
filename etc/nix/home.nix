{
  config,
  pkgs,
  lib,
  ...
}:

let
  editorBin = "${pkgs.vim}/bin/vim";

  # to get jamesdsp 2.4
  pkgs_6ec9e25 = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "6ec9e2520787f319a6efd29cb67ed3e51237af7e";
    sha256 = "6dYqPSYhADkK37uiKW4GnwA/FtfYeb70fUuxSwONnoI=";
  }) { inherit (pkgs) system; };

  den = pkgs.callPackage ./den.nix { };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
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
    ./apps/polybar.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    (pkgs.writeShellScriptBin "playerctl2" ''
      PLAYER=spotify
      ${playerctl}/bin/playerctl -p "$PLAYER" "$@"
    '')

    # generic util
    file
    zip
    wmctrl

    # installed globally
    # _1password-cli
    # _1password-gui

    # net util
    whois
    subnetcalc
    dnsutils

    # comfy util
    bat
    jq

    # random util
    neofetch

    # env/theme util
    # ulauncher

    # hardware util
    ddcutil

    # terminals
    alacritty
    kitty

    # coding
    vscode
    go
    python3
    rust-analyzer
    julia

    # dev tools
    pkg-config
    # gcc
    libgcc
    # libgccjit
    gfortran
    # binutils
    # blas
    # openblas

    # nixfmt
    nixfmt-rfc-style

    # audio
    alsa-scarlett-gui

    pavucontrol

    pkgs_6ec9e25.jamesdsp

    qpwgraph
    spotify
    cheese
    pulseaudio

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

    # polyden
    (buildGoModule rec {
      name = "polyden";
      version = "git";

      src =
        fetchFromGitHub {
          owner = "noriah";
          repo = "den";
          rev = "f81db82e0acc584b7ece344493231f8a908dc2d7";
          sha256 = "Vbj5l1ofN6vZt9sGzXQMdEnSkZsUAZtGds90mGSMljM=";
        }
        + "/src/polyden";

      vendorHash = "sha256-QduatMLXBdpmwNuTNcGDNS6oe8kmL/wNOJrKXBhzj6A=";

    })

    # catnip
    (buildGoModule rec {
      name = "catnip";
      version = "git";

      src = fetchFromGitHub {
        owner = "noriah";
        repo = "catnip";
        rev = "9c9f6e035030a590947e72d0c58fe2182f2fee2f";
        sha256 = "9gneteQIzbMNjg/08uq+pCbs2a32He2gL+hovxcJFzE=";
      };

      CGO_ENABLED = 0;

      vendorHash = "sha256-Hj453+5fhbUL6YMeupT5D6ydaEMe+ZQNgEYHtCUtTx4=";
    })

    den.pkgs.openrgb
    den.pkgs.openrgb-plugin-effects
    den.pkgs.openrgb-plugin-visual-map
  ];

  # nixpkgs.overlays = (pkgs.callPackage ./nixos/openrgb.nix { }).nixpkgs.overlays;

  home.file = {
    profile = {
      target = ".profile";
      text = ''
        export XDG_CONFIG_HOME="${config.xdg.configHome}";
        export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
        source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      '';
      force = true;
    };

    zshrc = {
      target = ".zshrc";
      text = ". ${den.etcDir}/zsh/zshrc";
      force = true;
    };

    zshenv = {
      target = ".zshenv";
      text = ''
        . ${den.homeDir}/.profile
        . ${den.etcDir}/zsh/zshenv
      '';
      force = true;
    };

    hushlogin = {
      target = ".hushlogin";
      text = "\n";
      force = true;
    };

    selected-editor = {
      target = ".selected_editor";
      text = ''
        SELECTED_EDITOR="${editorBin}"
      '';
      force = true;
    };

    tmux-config = {
      target = ".tmux.conf";
      source = "${den.etcDir}/tmux/tmux.conf";
      force = true;
    };

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

    vimrc = {
      target = ".vimrc";
      source = "${den.etcDir}/vim/rc.vim";
      force = true;
    };
  };

  home.sessionPath = [
    # node paths
    "./node_modules/.bin"
    "${config.programs.go.goPath}/bin"
    "${den.homeDir}/bin"
    "${den.homeDir}/rbin"
    "${den.homeDir}/opt/den/bin"
  ];

  home.sessionVariables = {
    EDITOR = editorBin;
    NIXPKGS_ALLOW_UNFREE = "1";

    # LD_LIBRARY_PATH = "${pkgs.gfortran.cc.lib}/lib:$LD_LIBRARY_PATH";

    # rust stuff
    RUSTUP_HOME = "${den.homeOptDir}/rustup";
    CARGO_HOME = "${den.homeOptDir}/cargo";

    # julia stuff
    # JULIA_HISTORY = "$HISTORY/julia_repl_history.jl";
    JULIA_DEPOT_PATH = "${den.homeOptDir}/julia";

    # node stuff
    NPM_PATH = "${den.homeOptDir}/npm";
    NPM_CONFIG_CACHE = "${den.homeOptDir}/npm/cache";
  };

  # prefer XDG directories
  home.preferXdgDirectories = true;

  xdg.configHome = "${den.homeDir}/.config";
  xdg.dataHome = den.homeVarDir;
  xdg.cacheHome = "${den.homeVarDir}/cache";
  xdg.stateHome = "${den.homeVarDir}/state";

  xdg.configFile = {
    "user-dirs.conf".text = "enabled=False\n";
    "user-dirs.conf".force = true;

    alacritty_config = {
      target = "alacritty";
      source = "${den.etcDir}/alacritty/default";
      force = true;
    };

    nix-fonts = {
      target = "fontconfig/conf.d/100-nix.conf";
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <!-- NIX_PROFILE is the path to your Nix profile. See Nix Reference Manual for details. -->
          <dir prefix="cwd">NIX_PROFILE/lib/X11/fonts</dir>
          <dir prefix="cwd">NIX_PROFILE/share/fonts</dir>
        </fontconfig>
      '';
      force = true;
    };

    openrgb-plugin-effects = {
      target = "OpenRGB/plugins/libOpenRGBEffectsPlugin.so";
      source = "${den.pkgs.openrgb-plugin-effects}/lib/openrgb/plugins/libOpenRGBEffectsPlugin.so";
      force = true;
    };

    openrgb-plugin-visual-map = {
      target = "OpenRGB/plugins/libOpenRGBVisualMapPlugin.so";
      source = "${den.pkgs.openrgb-plugin-visual-map}/lib/openrgb/plugins/libOpenRGBVisualMapPlugin.so";
      force = true;
    };
  };

  xdg.dataFile = {
    applications = {
      target = "applications";
      source = "${den.shareDir}/applications";
      recursive = true;
    };

    fonts = {
      target = "fonts";
      source = "${den.shareDir}/fonts";
      recursive = true;
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = false;

    desktop = "${den.homeDir}/desktop";
    download = "${den.homeDir}/downloads";
    documents = "${den.homeDir}/documents";
    pictures = "${den.homeDir}/pictures";
    music = "${den.homeDir}/music";
    videos = "${den.homeDir}/videos";

    templates = "${den.homeDir}/templates";

    publicShare = "${den.homeDir}/public";
  };

  xdg.desktopEntries = {
    alacritty-visualizer = {
      type = "Application";
      settings.TryExec = "alacritty";
      exec = "alacritty --config-file ${config.xdg.configHome}/alacritty/visualizer.toml";
      icon = "Alacritty";
      terminal = false;
      categories = [
        "System"
        "TerminalEmulator"
      ];
      name = "Visualizer";
      genericName = "Terminal";
      comment = "Alacritty Visualizer Profile";
    };
  };

  services.syncthing.enable = true;

  dconf.settings = with lib.hm.gvariant; {

    "org/gnome/desktop/interface" = {
      accent-color = "pink";
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [ "<Alt>space" ];
      close = [ "<Super>q" ];
      maximize = [ ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-up = [ ];
      move-to-workspace-left = [ "<Super><Shift>Page_Up" ];
      move-to-workspace-right = [ "<Super><Shift>Page_Down" ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-to-workspace-left = [ "<Super>Page_Up" ];
      switch-to-workspace-right = [ "<Super>Page_Down" ];
      unmaximize = [ ];
    };

    "org/gnome/desktop/wm/preferences" = {
      mouse-button-modifier = "<Control><Super>";
      resize-with-right-button = true;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      overlay-key = "''";
      workspaces-only-on-primary = true;
    };

    "org/gnome/mutter/keybindings" = {
      switch-monitor = [ "XF86Display" ];
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = [ "<Control><Super>q" ];
    };

    "org/gnome/shell" = {
      disabled-extensions = [
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "status-icons@gnome-shell-extensions.gcampax.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "dash-to-panel@jderose9.github.com"
      ];
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "mediacontrols@cliffniff.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
      remember-mount-password = false;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = false;
    };

    "org/gnome/shell/extensions/appindicator" = {
      tray-pos = "right";
    };

    # "org/gnome/shell/extensions/dash-to-panel" = {
    #   animate-appicon-hover = true;
    #   animate-appicon-hover-animation-type = "SIMPLE";
    #   appicon-margin = 4;
    #   appicon-padding = 4;
    #   appicon-style = "SYMBOLIC";
    #   dot-color-dominant = false;
    #   dot-color-override = false;
    #   dot-color-unfocused-different = false;
    #   dot-position = "BOTTOM";
    #   dot-size = 1;
    #   dot-style-focused = "METRO";
    #   dot-style-unfocused = "DASHES";
    #   focus-highlight = true;
    #   focus-highlight-dominant = false;
    #   focus-highlight-opacity = 25;
    #   group-apps = true;
    #   hotkeys-overlay-combo = "TEMPORARILY";
    #   intellihide = false;
    #   isolate-monitors = false;
    #   isolate-workspaces = false;
    #   leave-timeout = 50;
    #   leftbox-padding = -1;
    #   leftbox-size = 0;
    #   multi-monitors = false;
    #   panel-anchors = ''
    #     {"0":"MIDDLE"}
    #   '';
    #   panel-element-positions = ''
    #     {}
    #   '';
    #   panel-element-positions-monitors-sync = false;
    #   panel-lengths = ''
    #     {"0":91}
    #   '';
    #   panel-positions = ''
    #     {"0":"TOP"}
    #   '';
    #   panel-sizes = ''
    #     {"0":24}
    #   '';
    #   preview-custom-opacity = 50;
    #   preview-use-custom-opacity = true;
    #   primary-monitor = 0;
    #   scroll-icon-action = "CYCLE_WINDOWS";
    #   scroll-panel-action = "NOTHING";
    #   show-favorites = false;
    #   show-running-apps = true;
    #   show-showdesktop-hover = false;
    #   show-window-previews-timeout = 300;
    #   status-icon-padding = -1;
    #   trans-panel-opacity = 0.0;
    #   trans-use-custom-opacity = true;
    #   trans-use-dynamic-opacity = false;
    #   tray-padding = 6;
    #   window-preview-animation-time = 200;
    #   window-preview-hide-immediate-click = false;
    #   window-preview-title-position = "TOP";
    #   window-preview-use-custom-icon-size = false;
    # };

    "org/gnome/shell/extensions/mediacontrols" = {
      colored-player-icon = true;
      elements-order = [
        "ICON"
        "LABEL"
        "CONTROLS"
      ];
      extension-index = mkUint32 0;
      extension-position = "Center";
      fixed-label-width = true;
      label-width = mkUint32 200;
      labels-order = [
        " 🎵 "
        "TITLE"
        "-"
        "ARTIST"
      ];
      scroll-labels = true;
      show-control-icons-seek-backward = true;
      show-control-icons-seek-forward = true;
      show-player-icon = true;
    };

    "org/gnome/shell/extensions/workspace-indicator" = {
      embed-previews = false;
    };

    "org/gnome/shell/keybindings" = {
      shift-overview-down = [ "" ];
      shift-overview-up = [ "" ];
      toggle-overview = [ "<Super>c" ];
    };
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "noriah";
    userEmail = "vix@noriah.dev";
    signing.key = "C6ACD7663C0FE39B";

    ignores = [
      ".DS_Store"
      "*.sublime-project"
      "*.sublime-workspace"
      "*.code-workspace"
    ];

    extraConfig = {
      core.editor = editorBin;

      user.useConfigOnly = true;
      init.defaultBranch = "main";

      "filter \"lfs\"" = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };

    includes = [
      {
        condition = "gitdir:~/opt/den/.git";
        path = "~/workspace/public/.gitconfig";
      }
      {
        condition = "gitdir:~/workspace/public/";
        path = "~/workspace/public/.gitconfig";
      }
      {
        condition = "gitdir:~/workspace/notes/";
        path = "~/workspace/public/.gitconfig";
      }
      {
        condition = "gitdir:~/workspace/phase/";
        path = "~/workspace/phase/.gitconfig";
      }
    ];
  };

  programs.go = {
    enable = true;
    goPath = "opt/go";
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "monokai";
      editor.lsp.display-inlay-hints = true;
    };

    languages = {
      language-server.gopls.command = "${pkgs.gopls}/bin/gopls";
      language-server.rustls.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
        {
          name = "rust";
          auto-format = false;
          language-servers = [ "rustls" ];
        }
        {
          name = "go";
          auto-format = true;
          language-servers = [ "gopls" ];
          formatter.command = "${pkgs.gosimports}/bin/gosimports";
        }
      ];
    };
  };

  systemd.user.startServices = "sd-switch";

  #systemd.user.services.ulauncher-local = {
  #  Unit.Description = "Ulauncher service";
  #  Install.WantedBy = [ "default.target" ];
  #  Service = {
  #    Type = "dbus";
  #    BusName = "io.ulauncher.Ulauncher";
  #    Restart = "always";
  #    RestartSec = 1;
  #    ExecStart = ''${pkgs.ulauncher}/bin/ulauncher'';
  #  };
  #};

  systemd.user.services.jamesdsp = {
    Unit = {
      Description = "JamesDSP Audio Processor";
      After = "pipewire.service";
      BindsTo = "pipewire.service";
    };
    Install.WantedBy = [ "pipewire.service" ];
    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = ''${pkgs_6ec9e25.jamesdsp}/bin/jamesdsp --tray'';
      StandardError = "journal";
    };
  };
}
