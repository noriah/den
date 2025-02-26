{ config, pkgs, ... }:

let
  denOpenrgb = pkgs.callPackage ../../nix/packages/openrgb.nix { };
  no-rgb = pkgs.writeScriptBin "no-rgb" ''
    #!/bin/sh
    NUM_DEVICES=$(${denOpenrgb}/bin/openrgb --client 127.0.0.1:6742 --list-devices | grep -E '^[0-9]+: ' | wc -l)

    for i in $(seq 0 $(($NUM_DEVICES - 1))); do
      ${denOpenrgb}/bin/openrgb --client 127.0.0.1:6742 --device $i --mode static --color 000000
    done
  '';

  #openrgb_overlay = (final: prev: {
  #  openrgb = prev.openrgb.overrideAttrs {
  #    version = "git";
  #    src = pkgs.fetchFromGitLab {
  #      owner = "CalcProgrammer1";
  #      repo = "OpenRGB";
  #      rev = "d1cdea47c797ecf669ae1a5420e33c80a79558ba";
  #      hash = "sha256-SlkstIMQL1YO1EjeEiBrbikpj9muusVxQJlE1TD/mjQ=";
  #    };
  #    postInstall = ''
  #      substituteInPlace $out/lib/udev/rules.d/60-openrgb.rules \
  #        --replace "/usr/bin/env chmod" "${pkgs.coreutils}/bin/chmod"
  #    '';
  #  };
  #});

in
{
  #nixpkgs.overlays = [ openrgb_overlay ];

  environment.systemPackages = [ pkgs.i2c-tools ];

  hardware.i2c.enable = true;

  boot.kernelModules = [
    "i2c-dev"
    "i2c-piix4"
  ];

  systemd.services.no-rgb = {
    description = "no-rgb";
    wantedBy = [ "multi-user.target" ];
    after = [ "openrgb.service" ];
    serviceConfig = {
      ExecStart = "${no-rgb}/bin/no-rgb";
      Type = "oneshot";
    };
  };

  services.hardware.openrgb = {
    enable = true;
    package = denOpenrgb;
    motherboard = "amd";
    server.port = 6742;
  };
}
