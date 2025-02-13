{
  lib,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation rec {
  pname = "openrgb";
  version = "d1cdea47c797ecf669ae1a5420e33c80a79558ba";

  src = pkgs.fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = version;
    hash = "sha256-SlkstIMQL1YO1EjeEiBrbikpj9muusVxQJlE1TD/mjQ=";
  };

  nativeBuildInputs = with pkgs; [
    libsForQt5.qmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    libusb1
    hidapi
    mbedtls_2
    libsForQt5.qtbase
    libsForQt5.qttools
  ];

  postPatch = ''
    patchShebangs scripts/build-udev-rules.sh
    substituteInPlace scripts/build-udev-rules.sh \
      --replace /bin/chmod "${pkgs.coreutils}/bin/chmod"
  '';

  postInstall = ''
    substituteInPlace $out/lib/udev/rules.d/60-openrgb.rules \
      --replace "/usr/bin/env chmod" "${pkgs.coreutils}/bin/chmod"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    HOME=$TMPDIR $out/bin/openrgb --help > /dev/null
  '';

  meta = with lib; {
    description = "Open source RGB lighting control";
    homepage = "https://gitlab.com/CalcProgrammer1/OpenRGB";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "openrgb";
  };
}
