pkgs: {

  # to get jamesdsp 2.4, the last version that handles volume control properly
  pkgs_6ec9e25 = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "6ec9e2520787f319a6efd29cb67ed3e51237af7e";
    sha256 = "6dYqPSYhADkK37uiKW4GnwA/FtfYeb70fUuxSwONnoI=";
  }) { inherit (pkgs) system; };

  catnip = pkgs.buildGoModule rec {
    name = "catnip";
    version = "1.8.7";

    src = pkgs.fetchFromGitHub {
      owner = "noriah";
      repo = "catnip";
      rev = "v${version}";
      sha256 = "sha256-M9VGpDsBambe9kXyEgDg53pKOSL2zH1ugfSbRgAiaCo=";
    };

    env.CGO_ENABLED = 0;

    vendorHash = "sha256-Hj453+5fhbUL6YMeupT5D6ydaEMe+ZQNgEYHtCUtTx4=";
  };

  polyden = pkgs.buildGoModule rec {
    name = "polyden";
    version = "git";
    src =
      pkgs.fetchFromGitHub {
        owner = "noriah";
        repo = "den";
        rev = "c17e9f1fcb2fe2786fc2b1863f17d69facc7d1f9";
        sha256 = "o22KMEGpcd8MkqC0CD/s8rgPehR3+n9onjV3GFxh/7E=";
      }
      + "/src/polyden";
    vendorHash = "sha256-QduatMLXBdpmwNuTNcGDNS6oe8kmL/wNOJrKXBhzj6A=";
  };

  vcv-rack-pro = pkgs.callPackage ./vcv-rack.nix { };

  uxmidi-tools = pkgs.callPackage ./uxmidi-tools.nix { };

}
