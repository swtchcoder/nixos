{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      common = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    in {
      nixosConfigurations = {
        gaming = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = common ++ [
            ./graphical.nix
            ./gaming.nix
          ];
        };

        graphical = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = common ++ [
            ./graphical.nix
          ];
        };

        headless = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = common ++ [
            ./headless.nix
          ];
        };
      };
    };
}
