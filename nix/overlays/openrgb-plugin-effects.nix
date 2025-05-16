{
  lib,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation rec {
  pname = "openrgb-plugin-effects";
  version = "188bfc135df42e96a0658dc021204e08676b3025";

  src = pkgs.fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBEffectsPlugin";
    rev = version;
    hash = "sha256-FB+bppmoszmgIYl0ZhAU8eezOx3VTaTJ5R/2dJyOYoQ=";
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
    glib
    openal
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin";
    description = "Effects plugin for OpenRGB";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
