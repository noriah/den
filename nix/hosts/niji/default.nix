{
  pkgs,
  lib,
  outputs,
  ...
}:

{
  imports = [
    ./hardware.nix
    ./gdm-monitors.nix
    ./openrgb.nix
    # ./persist.nix

    # ./wireguard
  ];

  nixpkgs.overlays = [
    outputs.overlays.new-packages
    outputs.overlays.modified-packages
    outputs.overlays.unstable-packages
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "niji"; # Define your hostname.
  networking.domain = "home.noriah.dev";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # hardware.graphics.enable32Bit = true;
  # hardware.graphics.enable = true;
  # hardware.graphics.extraPackages = [ pkgs.amdvlk ];

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    #videoDrivers = [ "amdgpu" ];
    displayManager.gdm = {
      enable = true;
      #debug = true;
      wayland = true;
      autoSuspend = false;
    };
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
  };

  # programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts.packages = with pkgs; [
    #(nerdfonts.override { fonts = [ "FiraCode" ]; })
    nerd-fonts.fira-code
    fira-code
    twitter-color-emoji
  ];

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = false;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.resolved = {
    enable = false;
    domains = [
      # "~.sub.example.com"
      "~."
    ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vix = {
    isNormalUser = true;
    description = "vix";
    group = "vix";
    extraGroups = [
      "users"
      "networkmanager"
      "i2c"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGL53RzbJFXsmbaFsQofeUzM3jOE8jekkISLFzP9+L0 v@n.d_op"
    ];

    linger = true;
  };

  users.groups.vix.gid = 1000;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # pkgs for dynamic linked programs
    gfortran
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # enable zsh
  programs.zsh.enable = true;

  # enable mobile shell. this isn't used much right now.
  programs.mosh.enable = true;

  # steam must be enabled by system for things like firewall and udev rules.
  programs.steam.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "vix" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    curl
    git
    wget
    tmux
    ripgrep
    fd
    tree
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.tmux.enable = true;
  programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibername.enable = false;
    hybrid-sleep.enable = false;
  };

  services.logind.powerKey = "ignore";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 8922 ];

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
    };
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
      # workstation = true;
    };
  };

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  # allow user access to YubiHSM2
  services.udev.extraRules = ''
    SUBSYSTEM=="usb",ATTR{idVendor}=="1050",ATTR{idProduct}=="0030",MODE="0666",GROUP="wheel"
  '';

  # explicitly disable flatpak
  services.flatpak.enable = true;

  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [
    22000 # allow syncthing
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
