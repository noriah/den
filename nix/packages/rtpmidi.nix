{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation rec {
  pname = "rtpmidi";
  version = "24.12";

  src = fetchFromGitHub {
    owner = "davidmoreno";
    repo = "rtpmidid";
    rev = "v${version}";
    hash = "sha256-hiW0IKDAJnJjQrH6nQfr0QEAdVZvfEkpDR8yoF2JpAA=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];

  buildInputs = with pkgs; [
    avahi
    alsa-lib
    tree
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/rtpmidid $out/bin/rtpmidid
  '';

  meta = with lib; {
    description = "RTP MIDI User Space Driver Daemon for Linux";
    homepage = "https://github.com/davidmoreno/rtpmidid";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "rtpmidid";
  };
}
