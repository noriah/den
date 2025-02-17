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
    ./apps/alacritty.nix
    ./apps/git.nix
    ./apps/gnome.nix
    ./apps/openrgb.nix
    ./apps/polybar.nix
    ./audio.nix
    ./fonts.nix
    ./xdg.nix
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
    kitty

    # coding
    vscode
    go
    python3
    rust-analyzer
    julia
    # nixfmt
    nixfmt-rfc-style

    # dev util
    gnumake

    cheese

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
      text = "SELECTED_EDITOR=\"${den.editorBin}\"\n";
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
    EDITOR = den.editorBin;
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

  services.syncthing.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.go = {
    enable = true;
    goPath = "opt/go";
  };

  programs.gpg.enable = true;

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

}
