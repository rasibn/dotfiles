{
  description = "NixOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {
    nixpkgs,
    home-manager,
    zen-browser,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    desktopStateVersion = "24.11";
    laptopStateVersion = "25.05";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          stateVersion = desktopStateVersion;
        };
        modules = [
          ./hosts/desktop/hardware.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              stateVersion = desktopStateVersion;
              inherit inputs;
              inherit system;
            };
            home-manager.users.rasib = {
              imports = [
                ./home.nix
                ./hosts/desktop/default.nix
              ];
            };
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          stateVersion = laptopStateVersion;
        };
        modules = [
          ./hosts/laptop/hardware.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            powerManagement.enable = true;
            services.auto-cpufreq = {
              enable = true;
              settings = {
                battery = {
                  governor = "balanced";
                  turbo = "auto";
                };
                charger = {
                  governor = "performance";
                  turbo = "auto";
                };
              };
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              stateVersion = laptopStateVersion;
              inherit inputs;
              inherit system;
            };
            home-manager.users.rasib = {
              imports = [
                ./home.nix
                ./hosts/laptop/default.nix
              ];
            };
          }
        ];
      };
    };
  };
}
