# NixOS Home Manager Configuration

A modular NixOS configuration using Home Manager for managing user environments across desktop and laptop setups.

## Current Structure

```
nix-hm/
├── flake.nix                           # Main flake configuration
├── home.nix                            # Main home-manager config (240 lines - needs refactoring)
├── fish.nix                           # Fish shell configuration (extracted)
├── configuration.nix                   # NixOS system configuration
├── hosts/
│   ├── desktop.nix                    # Desktop-specific config (minimal)
│   └── laptop.nix                     # Laptop-specific config (minimal)
├── desktop-hardware-configuration.nix  # Desktop hardware config
└── laptop-hardware-configuration.nix   # Laptop hardware config
```

## Proposed Modular Structure

This is the target structure to implement gradually:

```
nix-hm/
├── flake.nix
├── home.nix                           # Simplified entry point
├── hosts/
│   ├── desktop/
│   │   ├── default.nix               # Desktop-specific overrides & packages
│   │   └── hardware.nix              # Hardware configuration
│   └── laptop/
│       ├── default.nix               # Laptop-specific overrides & packages
│       └── hardware.nix              # Hardware configuration
├── modules/
│   ├── core/
│   │   ├── packages.nix              # Base system packages
│   │   ├── environment.nix           # Environment variables & home.file configs
│   │   └── default.nix               # Core module imports
│   ├── programs/
│   │   ├── terminal/
│   │   │   ├── tmux.nix              # Tmux configuration
│   │   │   ├── wezterm.nix           # Wezterm configuration
│   │   │   └── default.nix           # Terminal program imports
│   │   ├── development/
│   │   │   ├── git.nix               # Git configuration
│   │   │   ├── languages.nix         # Go, Node, Python, Rust toolchains
│   │   │   ├── editors.nix           # LSPs, formatters, etc.
│   │   │   └── default.nix           # Development tool imports
│   │   ├── desktop/
│   │   │   ├── hyprland.nix          # Hyprland window manager
│   │   │   ├── waybar.nix            # Status bar
│   │   │   ├── rofi.nix              # Application launcher
│   │   │   └── default.nix           # Desktop environment imports
│   │   ├── browsers.nix              # Firefox, Brave, Chrome
│   │   ├── media.nix                 # Media applications
│   │   └── default.nix               # All program imports
│   ├── services/
│   │   ├── notifications.nix         # Mako notification daemon
│   │   ├── idle.nix                  # Hypridle configuration
│   │   ├── clipboard.nix             # Cliphist clipboard manager
│   │   └── default.nix               # Service imports
│   └── default.nix                   # All module imports
├── profiles/
│   ├── base.nix                      # Minimal base configuration
│   ├── desktop.nix                   # Full desktop environment
│   ├── laptop.nix                    # Laptop-optimized configuration
│   └── development.nix               # Development-focused setup
└── README.md                         # This file
```

## Migration Strategy

### Phase 1: Extract Major Components (Safe & Gradual)

1. **Extract Programs** (one at a time):

   - `modules/programs/terminal/tmux.nix` - Extract tmux config
   - `modules/programs/development/git.nix` - Extract git config
   - `modules/programs/browsers.nix` - Extract browser configs
   - `modules/programs/development/languages.nix` - Extract language toolchains

2. **Extract Services**:

   - `modules/services/notifications.nix` - Extract mako config
   - `modules/services/idle.nix` - Extract hypridle config
   - `modules/services/clipboard.nix` - Extract cliphist config

3. **Extract Core Components**:
   - `modules/core/packages.nix` - Extract package lists
   - `modules/core/environment.nix` - Extract environment vars and home.file

### Phase 2: Organize by Category

4. **Create Module Categories**:
   - Create `modules/programs/default.nix` to import all program modules
   - Create `modules/services/default.nix` to import all service modules
   - Create `modules/core/default.nix` to import core modules

### Phase 3: Host-Specific Configurations

5. **Enhance Host Configs**:
   - Move hardware configs to `hosts/*/hardware.nix`
   - Add host-specific packages and overrides to `hosts/*/default.nix`
   - Update flake.nix to use new host structure

### Phase 4: Profiles (Optional)

6. **Create Profiles**:
   - `profiles/base.nix` - Minimal config for servers/headless
   - `profiles/desktop.nix` - Full desktop environment
   - `profiles/laptop.nix` - Battery-optimized desktop environment

## Migration Guidelines

### Safety First

- **One module at a time**: Extract one component, test with `nix flake check`, then commit
- **Keep backups**: Always commit working configurations before major changes
- **Test thoroughly**: Run `nswitchu` after each change to ensure everything works
- **Rollback ready**: Know how to rollback with `sudo nixos-rebuild switch --rollback`

### Testing Commands

```bash
# Check flake syntax
nix flake check

# Build without applying (test)
sudo nixos-rebuild build --flake .#desktop

# Apply changes (after testing)
nswitchu  # or your custom rebuild command
```

### Example Module Structure

Each module should follow this pattern:

```nix
# modules/programs/terminal/tmux.nix
{
  config,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    # ... tmux configuration
  };
}
```

```nix
# modules/programs/terminal/default.nix
{
  imports = [
    ./tmux.nix
    ./wezterm.nix
  ];
}
```

## Benefits of Modular Structure

1. **Maintainability**: Each component is self-contained and easy to modify
2. **Reusability**: Modules can be easily shared between hosts
3. **Flexibility**: Easy to enable/disable features per host
4. **Clarity**: Clear separation of concerns
5. **Scalability**: Easy to add new modules or hosts
6. **Debugging**: Easier to isolate issues to specific modules

## Host-Specific Customization

After migration, you can easily customize per host:

```nix
# hosts/laptop/default.nix
{
  # Laptop-specific packages
  home.packages = with pkgs; [
    powertop
    tlp
  ];

  # Override desktop modules for laptop
  programs.waybar.settings.battery = {
    states = {
      warning = 30;
      critical = 15;
    };
  };
}
```

## Current Migration Status

- ✅ `fish.nix` - Fish shell configuration extracted
- ⏳ Remaining 240 lines in `home.nix` to be modularized

## Notes

- This is a living document - update as you implement changes
- Always test on a non-critical system first if possible
- Consider using `nixos-rebuild build` to test before applying
- Keep the old structure until fully migrated and tested
