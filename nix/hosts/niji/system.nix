{ lib, pkgs, ... }:
{

  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

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

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    #videoDrivers = [ "amdgpu" ];
    displayManager.gdm = {
      enable = true;
      #debug = true;
      wayland = false;
      autoSuspend = false;
    };
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
  };

  services.gnome = {
    gnome-keyring.enable = true;
    gnome-settings-daemon.enable = true;
    gnome-user-share.enable = true;

    evolution-data-server.enable = lib.mkForce false;
    gnome-remote-desktop.enable = lib.mkForce false;
    gnome-online-accounts.enable = lib.mkForce false;
    games.enable = lib.mkForce false;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    fira-code
    fira-sans
    twitter-color-emoji
  ];

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vix = {
    isNormalUser = true;
    description = "vix";
    group = "vix";
    extraGroups = [
      "users"
      # "networkmanager"
      "i2c"
      "wheel"
      "wireshark"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGL53RzbJFXsmbaFsQofeUzM3jOE8jekkISLFzP9+L0 v@n.d_op"
    ];

    linger = false;
  };

  users.groups.vix.gid = 1000;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # pkgs for dynamic linked programs
    gfortran
  ];

  # Install firefox.
  # programs.firefox.enable = true;

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

  nixpkgs.config.permittedInsecurePackages = [
    "mbedtls-2.28.10"
  ];

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

    iptables

    usbutils
    pciutils
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

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  # allow user access to YubiHSM2
  services.udev.extraRules = ''
    SUBSYSTEM=="usb",ATTR{idVendor}=="1050",ATTR{idProduct}=="0030",MODE="0666",GROUP="wheel"
  '';

  # explicitly ~~disable~~ flatpak
  services.flatpak.enable = true;

  # services.synergy.client = {
  #   enable = true;
  #   autoStart = false;
  #   serverAddress = "vyxn.mobile.noriah.dev";
  # };

}
