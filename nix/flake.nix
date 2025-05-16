{
  description = "noriah's den";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # for later
    # impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      repoRoot = ../.;

      lib = nixpkgs.lib // home-manager.lib;

      systems = [
        # "aarch64-linux"
        # "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        # "x86_64-darwin"
      ];

      forEachSystem = lib.genAttrs systems;
    in
    {

      packages = forEachSystem (system: import ./pkgs nixpkgs.legacyPackages.${system});

      nixosConfigurations = {
        poppy = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ../nixos/poppy/config.nix
            nixos-hardware.nixosModules.framework-13-7040-amd
          ];
        };
      };

      homeConfigurations = {
        "vix@poppy" = lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            {
              den.hostName = "poppy";
              den.dir.home = "/home/vix";
              den.store = repoRoot;
            }
            ./home/home.nix
          ];
        };
      };

    };
}
