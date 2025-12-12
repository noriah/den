{
  lib,
  stdenv,
  fetchurl,
  gtk-engine-murrine,
}:

# TODO: grab source from https://github.com/EliverLara/Juno, customize colors of
# PNG assets. these come from SVG sources, rendered out to individual images
# change the color in SVG, then render out to achieve color changes. see budgie
# control center for example of mismatched colors (yellow when pink is desired).

stdenv.mkDerivation rec {
  pname = "juno";
  version = "0.0.3";

  srcs = [
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno-mirage.tar.xz";
      sha256 = "sha256-VU8uNH6T9FyOWgIfsGCCihnX3uHfOy6dXsANWKRPQ1c=";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Juno* $out/share/themes
    rm $out/share/themes/*/{LICENSE,README.md}
    runHook postInstall
  '';

  postInstall = ''
    files=$(find $out/share/themes/ -type f -exec grep -Iq . {} \; -printf '%p ')
    substituteInPlace $files \
      --replace-quiet "#4c463b" "#4c3b41" \
      --replace-quiet "#625640" "#62404c" \
      --replace-quiet "#796746" "#794658" \
      --replace-quiet "#8f784b" "#8f4b62" \
      --replace-quiet "#a58950" "#a5506c" \
      --replace-quiet "#e6b85c" "#e65c8a" \
      --replace-quiet "#ffe6b3" "#ffb3cc" \
      --replace-quiet "#ffdd99" "#ff99bb" \
      --replace-quiet "#ffd580" "#ff80aa" \
      --replace-quiet "#ffd88a" "#ff8ab1" \
      --replace-quiet "#fad07b" "#fa7ba5" \
      --replace-quiet "#ffd175" "#ff75a3" \
      --replace-quiet "#ffcc66" "#ff6699" \
      --replace-quiet "#ffc552" "#ff4d88" \
      --replace-quiet "#ffc44d" "#ff528c" \
      --replace-quiet "#ffbb33" "#ff3377" \
      --replace-quiet "rgba(255, 204, 102," "rgba(255, 102, 153," \
      --replace-quiet "rgba(250, 208, 123," "rgba(250, 123, 165," \
      --replace-quiet "rgba(213, 173, 92," "rgba(213, 92, 132," \
      --replace-quiet "rgba(130, 110, 72," "rgba(130, 72, 92," \
      --replace-quiet "linear-gradient(to right, #2b3243);" "linear-gradient(to right, #2b3243, #2b3243);"
  '';

  meta = with lib; {
    description = "GTK themes inspired by epic vscode themes";
    homepage = "https://github.com/EliverLara/Juno";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.gvolpe ];
  };
}
