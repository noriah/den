{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{

  networking.hostName = "niji"; # Define your hostname.
  networking.domain = "den.noriah.dev";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = false;

  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [
    22000 # allow syncthing
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  programs.wireshark.enable = true;

  # networking.hostId = "be575255";

  networking.interfaces.enp8s0.useDHCP = true;

  # networking.vlans.phase28 = {
  #   id = 28;
  #   interface = "enp8s0";
  # };

  # networking.interfaces.phase28 = {
  #   macAddress = "c8:f8:58:7d:7d:01";

  #   ipv4 = {
  #     # routes = [
  #     #   {
  #     #     address = "10.8.3.1";
  #     #     prefixLength = 32;
  #     #     via = "10.0.28.1";
  #     #     # options.scope = "global";
  #     #   }
  #     #   {
  #     #     address = "10.10.0.0";
  #     #     prefixLength = 16;
  #     #     via = "10.8.3.1";
  #     #     # options.scope = "global";
  #     #   }
  #     # ];
  #     addresses = [
  #       {
  #         address = "10.0.28.5";
  #         prefixLength = 24;
  #       }
  #     ];
  #   };
  # };

  services.resolved = {
    enable = false;
    domains = [
      # "~.sub.example.com"
      "~."
    ];
    # extraConfig = ''
    #   DNS=10.10.0.3%phase28#phase.bar
    # '';
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
      # workstation = true;
    };
  };

}
