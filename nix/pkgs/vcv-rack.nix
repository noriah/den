{
  stdenv,
  lib,
  pkgs,
  ...
}:

pkgs.vcv-rack.overrideAttrs (old: {
  # https://community.vcvrack.com/t/vcv-rack-2-on-nixos-nix/16007/7
  name = "VCV-RackPro";
  version = "2.6.6";
  src = pkgs.requireFile {
    # https://vcvrack.com/RackProDownload?version=2.6.4&arch=lin-x64
    message = "run \"nix store add-file RackPro-2.6.6-lin-x64.zip\"";
    name = "RackPro-2.6.6-lin-x64.zip";
    # sha256 obtained with: nix-hash --flat --type sha256 RackPro-2.6.4-lin-x64.zip
    sha256 = "88b170fb267dab127a09fb4502e5d629757b106e52578b01796cb94bbae6ab47";
  };
  nativeBuildInputs = with pkgs; [
    copyDesktopItems
    makeWrapper
    wrapGAppsHook3
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
    cp -r Fundamental-2.6.4-lin-x64.vcvplugin LICENSE.html template.vcv template-plugin.vcv $out/share/vcv-rack

    runHook postInstall
  '';
  # set RACK_SYSTEM_DIR env variable
  postInstall = (if old ? postInstall then old.postInstall else "") + ''
    wrapProgram $out/bin/Rack --set RACK_SYSTEM_DIR  $out
  '';
  meta.description = "Open-source virtual modular synthesizer -- paid edition";
})
