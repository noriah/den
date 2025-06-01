{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  luksRootName = "luks_nixos";
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "vfat"
    "nls_cp437"
    "nls_iso8859-1"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.kernelParams = [
    "video=DP-1:2560x1440@165"
    "video=DP-2:2560x1440@60"
    "video=DP-3:2560x1440@60"
  ];

  #boot.kernelPatches = [{
  #  name = "NCT6775 driver";
  #  patch = null;
  #  extraStructureConfig = with lib.kernel; {
  #    I2C_NCT6775 = lib.mkForce yes;
  #  };
  #}];

  # Disabled to use yubikey at boot
  boot.initrd.systemd.enable = false;

  boot.initrd.luks.yubikeySupport = true;
  #boot.initrd.luks.cryptoModules = [ "aes" "xts" "sha512" ];
  boot.initrd.luks.devices.${luksRootName} = {
    device = "/dev/disk/by-uuid/a1684881-69a0-4893-8f11-2dbf34d7765e";
    #preLVM = true;

    yubikey = {
      slot = 2;
      twoFactor = false;
      gracePeriod = 1;
      keyLength = 64;
      saltLength = 16;

      storage = {
        device = "/dev/disk/by-uuid/CE5F-2E8A";
        fsType = "vfat";
        path = "/crypt-storage/default";
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9daf62cb-2ef6-4b93-8946-daceafe96fd7";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CE5F-2E8A";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/402a4ff8-ed7c-4681-b46c-f140858c249d";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/bb89d350-c95d-4e60-b6be-5678537f4005";
    fsType = "ext4";
  };

  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/666a4fb5-c418-403f-af86-96f593aac66e";
    fsType = "ext4";
  };

  fileSystems."/backup/old_root" = {
    device = "/dev/disk/by-uuid/c6fac4e7-90ec-4c20-8bf9-417098090aea";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/1553f220-7e15-4fbb-a21c-65520f047b7c"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
