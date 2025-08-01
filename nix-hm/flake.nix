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
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {stateVersion = desktopStateVersion;};
        modules = [
          ./desktop-hardware-configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {stateVersion = desktopStateVersion;};
            home-manager.users.rasib = {
              imports = [
                ./home.nix
                ./hosts/desktop.nix
              ];
            };
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {stateVersion = laptopStateVersion;};
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {stateVersion = laptopStateVersion;};
            home-manager.users.rasib = {
              imports = [
                ./home.nix
                ./hosts/laptop.nix
              ];
            };
          }
        ];
      };
    };
  };
}
