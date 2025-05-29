{
  description = "NixOs configuration";

  inputs = {
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs: 
	let 
		system = "x86_64-linux";
	in
	{
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.rasib = ./home.nix;
					# Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
				 }
			];
		};
	};
}

