{
  description = "NixOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    desktopStateVersion = "24.11";
    laptopStateVersion = "25.05";
    pkgs = nixpkgs.legacyPackages.${system};

    # Custom packages
    proji = pkgs.buildGoModule {
      pname = "proji";
      version = "1.0.0";
      src = ../shared/scripts/golang/proji;
      vendorHash = "sha256-2adRLsTSd0vTGcis5FfOT5ZFgB420nvDqHkEEopmgec=";
      meta = with pkgs.lib; {
        description = "Tmux session manager with directory selection";
        license = licenses.mit;
      };
    };
    nvimi = pkgs.buildGoModule {
      pname = "nvimi";
      version = "1.0.0";
      src = ../shared/scripts/golang/nvimi;
      vendorHash = "sha256-2adRLsTSd0vTGcis5FfOT5ZFgB420nvDqHkEEopmgec=";
      meta = with pkgs.lib; {
        description = "fzf based file picker for neovim";
        license = licenses.mit;
      };
    };
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
              inherit proji;
              inherit nvimi;
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
            powerManagement.powertop.enable = true;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              stateVersion = laptopStateVersion;
              inherit proji;
              inherit nvimi;
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
