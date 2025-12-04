{
  stdenv,
  lib,
  pkgs,
  ...
}:

stdenv.mkDerivation rec {
  pname = "uxmidi-tools";
  version = "7.4";

  src = pkgs.fetchzip {
    url = "https://www.cme-pro.com/wp-content/uploads/2025/02/UxMIDI-Tools-V${version}.zip";
    sha256 = "sha256-U2nVArTXKvzuaFtJ7rdn7sln3pB496t6lc1tHrPobWM=";
    stripRoot = false;
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
  ];

  # List runtime libraries your binary needs
  buildInputs = with pkgs; [
    alsa-lib
    freetype
    # curlWithGnuTls
    libgcc.lib
    openssl
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v UxMIDI\ Tools $out/bin/uxmidi-tools
  '';

  meta = with lib; {
    description = "UxMidi Tools";
    homepage = "https://www.cme-pro.com/support";
    license = licenses.mit; # or correct one
    platforms = platforms.linux;
  };
}
