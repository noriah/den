{
  lib,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation rec {
  pname = "openrgb-plugin-visual-map";
  version = "b3162ce12c4a3de34206be1862bf4ffb4672f051";

  src = pkgs.fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBVisualMapPlugin";
    rev = version;
    hash = "sha256-g4aLaPIrA/EsOUdK4/wk87hdVk5gDZJGx+Li5typyUI=";
    fetchSubmodules = true;
  };

  # postPatch = ''
  #   # Use the source of openrgb from nixpkgs instead of the submodule
  #   rm -r OpenRGB
  #   ln -s ${openrgb.src} OpenRGB
  # '';

  nativeBuildInputs = with pkgs; [
    libsForQt5.qmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    libsForQt5.qtbase
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBVisualMapPlugin";
    description = "Visual map plugin for OpenRGB";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
