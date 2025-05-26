{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
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

  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "poppy"; # Define your hostname.
  networking.domain = "mobile.noriah.dev";

  services.resolved = {
    enable = false;
    domains = [ "~." ];
  };

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk.enable = false;
    greeters.slick.enable = false;
    greeters.mini = {
      enable = true;
      user = "vix";
      extraConfig = ''
        [greeter]
        show-password-label = false
        show-input-cursor = false
        password-alignment = center
        invalid-password-text = ???
        show-sys-info = true

        [greeter-hotkeys]
        mod-key = meta
        shutdown-key = s
        restart-key = r
        hubernate-key = h
        suspend-key = e

        [greeter-theme]
        background-image = ""
        background-color = "#272822"
        window-color = "#FF6F66"
      '';
    };
  };
  services.xserver.desktopManager.budgie.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira-code
  ];

  services.fwupd.enable = true;

  # uses CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  users.groups.vix.gid = 1000;

  # Install firefox.
  programs.firefox.enable = true;

  # enable zsh
  programs.zsh.enable = true;

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
  ];

  # explicitly disable flatpak
  services.flatpak.enable = false;

  networking.firewall.enable = true;
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
