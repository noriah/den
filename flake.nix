{
  description = "noriah's den";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-legacy.url = "github:NixOS/nixpkgs/nixos-24.11";

    # for later
    # impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    #home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-legacy.url = "github:nix-community/home-manager/release-24.11";
    home-manager-legacy.inputs.nixpkgs.follows = "nixpkgs-legacy";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-legacy,
      home-manager,
      home-manager-legacy,
      nixos-hardware,
      ...
    }@inputs:
    let
      inherit (self) outputs;

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

      overlays = import ./nix/overlays { inherit inputs; };

      packages = forEachSystem (system: import ./nix/pkgs nixpkgs.legacyPackages.${system});

      nixosConfigurations = {
        niji = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nix/hosts/niji ];
        };

        poppy = nixpkgs-legacy.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nix/hosts/poppy ];
        };
      };

      homeConfigurations = {
        "vix@niji" = lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            {
              den.enable = true;
              den.hostName = "niji";
            }
            ./nix/home
          ];
        };

        "vix@poppy" = home-manager-legacy.lib.homeManagerConfiguration {
          pkgs = nixpkgs-legacy.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            {
              den.enable = true;
              den.hostName = "poppy";
            }
            ./nix/home
          ];
        };

        "nor@ersa" = lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            {
              den.enable = true;
              den.hostName = "ersa";
            }
            ./nix/home
          ];
        };

        "noriah@vyxn" = lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            {
              den.enable = true;
              den.hostName = "vyxn";
            }
            ./nix/home
          ];
        };

      };

    };
}
