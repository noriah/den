pkgs: {

  # to get jamesdsp 2.4, the last version that handles volume control properly
  pkgs_6ec9e25 = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "6ec9e2520787f319a6efd29cb67ed3e51237af7e";
    sha256 = "6dYqPSYhADkK37uiKW4GnwA/FtfYeb70fUuxSwONnoI=";
  }) { inherit (pkgs) system; };

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

  vcv-rack-pro = pkgs.vcv-rack.overrideAttrs (old: {
    # https://community.vcvrack.com/t/vcv-rack-2-on-nixos-nix/16007/7
    name = "VCV-RackPro";
    version = "2.6.4";
    src = pkgs.requireFile {
      # https://vcvrack.com/RackProDownload?version=2.6.4&arch=lin-x64
      message = "run \"nix store add-file RackPro-2.6.4-lin-x64.zip\"";
      name = "RackPro-2.6.4-lin-x64.zip";
      # sha256 obtained with: nix-hash --flat --type sha256 RackPro-2.6.4-lin-x64.zip
      sha256 = "e193806d54b41ca3da3488d05d1d6729e46068c3ebdee9f7e6c3961706bc3cfe";
    };
    nativeBuildInputs = with pkgs; [
      copyDesktopItems
      makeWrapper
      wrapGAppsHook
      autoPatchelfHook
      unzip
    ];
    buildInputs = old.buildInputs ++ [
      pkgs.stdenv.cc.cc.lib # for providing libstdc++.so.6 and libgcc_s.so.1
      pkgs.stdenv.cc.libc # for providing libc.so.6 and libm.so.6
    ];
    unpackPhase = ''
      unzip $src
    '';
    prePatch = "";
    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall

      # copy vst/clap plugins
      mkdir -p $out/lib/vst
      cp 'VCV Rack 2.so' $out/lib/vst
      cp -r 'VCV Rack 2.vst3' $out/lib/vst
      mkdir -p $out/lib/clap
      cp 'VCV Rack 2.clap' $out/lib/clap

      # copy vcv rack
      mkdir -p $out/bin
      cd Rack2Pro
      cp Rack $out/bin
      cp libRack.so $out/lib

      # Rack needs to find the directory Rack2Pro, at one of these locations:
      # - ~/.local/share/VCV/
      # - $XDG_DATA_HOME/VCV/
      # - /usr/share/VCV/
      # - /opt/VCV/
      # or through the variable RACK_SYSTEM_DIR.
      cd ../
      cp -r Rack2Pro $out
      cd Rack2Pro

      mkdir -p $out/share/vcv-rack
      cp -r cacert.pem Core.json res translations $out/share/vcv-rack
      cp -r Fundamental-2.6.2-lin-x64.vcvplugin LICENSE.html template.vcv template-plugin.vcv $out/share/vcv-rack

      runHook postInstall
    '';
    # set RACK_SYSTEM_DIR env variable
    postInstall = (if old ? postInstall then old.postInstall else "") + ''
      wrapProgram $out/bin/Rack --set RACK_SYSTEM_DIR  $out
    '';
    meta.description = "Open-source virtual modular synthesizer -- paid edition";
  });

  uxmidi-tools = pkgs.callPackage ./uxmidi-tools.nix { };

}
