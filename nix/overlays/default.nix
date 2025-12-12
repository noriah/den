{ inputs, ... }:
{

  new-packages = final: _prev: import ../pkgs final.pkgs;

  modified-packages = final: prev: {

    juno-theme = prev.callPackage ./juno-theme.nix { };

    openrgb = prev.callPackage ./openrgb.nix { };
    openrgb-plugin-effects = prev.callPackage ./openrgb-plugin-effects.nix { };
    openrgb-plugin-visual-map = prev.callPackage ./openrgb-plugin-visual-map.nix { };

    # r2modman = prev.callPackage ./r2modman { };

    rtpmidi = prev.callPackage ./rtpmidi.nix { };

    # firefox = prev.firefox.overrideAttrs (oldAttrs: {
    #   postInstall =
    #     (oldAttrs.postInstall or "")
    #     + ''
    #       substituteInPlace $out/share/applications/firefox.desktop \
    #         --replace "Name=Firefox" "Name=Web Browser"
    #     '';
    # });

  };

  unstable-packages = final: _prev: {

    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };

  };

}
