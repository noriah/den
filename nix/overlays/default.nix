{ inputs, ... }:
{

  new-packages = final: _prev: import ../pkgs final.pkgs;

  modified-packages = final: prev: {

    openrgb = prev.callPackage ./openrgb.nix { };
    openrgb-plugin-effects = prev.callPackage ./openrgb-plugin-effects.nix { };
    openrgb-plugin-visual-map = prev.callPackage ./openrgb-plugin-visual-map.nix { };

    r2modman = prev.callPackage ./r2modman { };

    rtpmidi = prev.callPackage ./rtpmidi.nix { };

  };

  unstable-packages = final: _prev: {

    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };

  };

}
