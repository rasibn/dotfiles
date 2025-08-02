# Adding Go Binaries to NixOS Configuration

This guide explains how to package Go binaries and add them to your NixOS configuration for reproducible builds across machines.

## Overview

Instead of manually building Go binaries and adding them to PATH, we package them with Nix to ensure:
- Reproducible builds on any machine
- Automatic dependency management
- Integration with NixOS package management
- No manual compilation steps required

## Step-by-Step Process

### 1. Understand the Current Setup

Your NixOS configuration uses a flake-based approach where:
- Go binaries are defined in `nix-hm/flake.nix`
- They're added to packages in `nix-hm/modules/core/packages.nix`
- Dependencies are automatically resolved by Nix

### 2. Get the Vendor Hash

The vendor hash ensures reproducible builds by verifying Go dependencies. Here's how to get it:

#### Method 1: Use a Dummy Hash (Recommended)
```nix
# In flake.nix, add your package with a dummy hash
nvimi = pkgs.buildGoModule {
  pname = "nvimi";
  version = "1.0.0";
  src = ../shared/scripts/golang/nvimi;
  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  meta = with pkgs.lib; {
    description = "Fuzzy-find and open files in Neovim";
    license = licenses.mit;
  };
};
```

Then run `nswitchu`. Nix will fail with an error showing the correct hash:
```
error: hash mismatch in fixed-output derivation
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-2adRLsTSd0vTGcis5FfOT5ZFgB420nvDqHkEEopmgec=
```

Copy the "got" hash and use it in your configuration.

#### Method 2: Use Nix Commands (Alternative)
```bash
# From the Go module directory
cd shared/scripts/golang/nvimi
nix-shell -p go --run "go mod download"
nix hash path $(go env GOMODCACHE)
```

### 3. Add nvimi to Your Flake

Edit `nix-hm/flake.nix` and add nvimi to the custom packages section:

```nix
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

  # Add nvimi here
  nvimi = pkgs.buildGoModule {
    pname = "nvimi";
    version = "1.0.0";
    src = ../shared/scripts/golang/nvimi;
    vendorHash = "sha256-YOUR_VENDOR_HASH_HERE";  # Replace with actual hash
    meta = with pkgs.lib; {
      description = "Fuzzy-find and open files in Neovim";
      license = licenses.mit;
    };
  };
in {
```

### 4. Pass nvimi to NixOS Configurations

Update both desktop and laptop configurations to include nvimi:

```nix
nixosConfigurations = {
  desktop = nixpkgs.lib.nixosSystem {
    specialArgs = {stateVersion = desktopStateVersion; inherit proji nvimi;};
    modules = [
      ./hosts/desktop/hardware.nix
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {stateVersion = desktopStateVersion; inherit proji nvimi;};
        # ... rest of config
      }
    ];
  };

  laptop = nixpkgs.lib.nixosSystem {
    specialArgs = {stateVersion = laptopStateVersion; inherit proji nvimi;};
    modules = [
      ./hosts/laptop/hardware.nix
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {stateVersion = laptopStateVersion; inherit proji nvimi;};
        # ... rest of config
      }
    ];
  };
};
```

### 5. Add nvimi to Your Packages

Edit `nix-hm/modules/core/packages.nix`:

```nix
{
  config,
  pkgs,
  proji,
  nvimi,  # Add this parameter
  ...
}: {
  home.packages = with pkgs; [
    # ... existing packages ...

    # Custom packages
    proji
    nvimi  # Add this line
  ];
}
```

### 6. Remove Python Alias

Edit `nix-hm/modules/programs/terminal/fish.nix` to remove the Python nvimi alias:

```nix
shellAliases = {
  vim = "nvim";

  # nvimi = "python $DOTFILE_DIR/shared/scripts/python/nvimi.py";  # Remove this line
  vimi = "$DOTFILE_DIR/shared/scripts/nvim-fzf.sh";

  # ... rest of aliases
};
```

### 7. Commit and Apply Changes

```bash
cd /home/rasib/assets/dotfiles
git add .
git commit -m "Add nvimi Go binary to NixOS configuration"
nswitchu
```

## Complete Example for nvimi

Based on the nvimi Go code you have, here's the complete addition:

### flake.nix addition:
```nix
nvimi = pkgs.buildGoModule {
  pname = "nvimi";
  version = "1.0.0";
  src = ../shared/scripts/golang/nvimi;
  vendorHash = "sha256-2adRLsTSd0vTGcis5FfOT5ZFgB420nvDqHkEEopmgec=";  # Same as proji since same dependencies
  meta = with pkgs.lib; {
    description = "Fuzzy-find and open files in Neovim with fzf integration";
    license = licenses.mit;
  };
};
```

## Troubleshooting

### Common Issues

1. **"path does not exist" error**: Make sure the Go module directory exists and contains go.mod
2. **Hash mismatch**: Use the dummy hash method to get the correct vendor hash
3. **Build failures**: Check that go.mod and go.sum are properly committed to git
4. **Import errors**: Ensure all parameters are passed correctly through the specialArgs chain

### Testing Your Package

After applying changes:

```bash
# Verify the binary is available
which nvimi
nvimi --help

# Test functionality
nvimi  # Should open fzf file selector
```

## Benefits of This Approach

- **Reproducible**: Works on any machine with your dotfiles
- **No manual builds**: Nix handles compilation automatically  
- **Dependency management**: Go dependencies are locked and verified
- **Integration**: Works seamlessly with NixOS package management
- **Version control**: Binary versions are tracked in your configuration

## Additional Go Binaries

To add more Go binaries, repeat this process:
1. Get vendor hash using dummy hash method
2. Add to flake.nix custom packages section
3. Pass through specialArgs
4. Add to packages.nix
5. Remove any old aliases
6. Commit and rebuild

This approach scales to any number of custom Go tools while maintaining reproducibility.