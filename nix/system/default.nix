{ outputs, ... }:
{
  imports = [
    ./hosts
    ./modules
  ];

  nixpkgs.overlays = [
    outputs.overlays.new-packages
    outputs.overlays.modified-packages
    outputs.overlays.unstable-packages
  ];
}
