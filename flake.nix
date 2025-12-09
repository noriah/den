{
  description = "noriah's den";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # for later
    # impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
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
        poppy = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nix/hosts/poppy ];
        };
      };

      homeConfigurations = {

        "vix@niji" = lib.homeManagerConfiguration {
          # TODO(user-data): move niji home to separate physical drive
          # (complete, but) how should this be documented / is it relevant here?
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            {
              den.enable = true;
              den.hostName = "niji";
              home.stateVersion = "24.11";
            }
            ./nix/home
          ];
        };

        "vix@poppy" = lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            {
              den.enable = true;
              den.hostName = "poppy";
              home.stateVersion = "24.11";
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
              home.stateVersion = "24.11";
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
              home.stateVersion = "25.05";
            }
            ./nix/home
          ];
        };

      };
    };
}
