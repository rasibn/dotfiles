# NixOS Home-Manager Configuration Agent Guide

## Build Commands
- `sudo nixos-rebuild switch --flake .#desktop` - Build and apply desktop configuration
- `sudo nixos-rebuild switch --flake .#laptop` - Build and apply laptop configuration
- `nswitchu` (shell alias) - Auto-detect host and rebuild (detects laptop via battery presence)
- `nix flake update` - Update flake inputs
- `home-manager switch` - Apply home-manager changes only

## Code Style Guidelines
- **Language**: Nix configuration language
- **Formatting**: Use nixpkgs-fmt or alejandra for consistent formatting
- **Imports**: Group imports at top, separate system modules from custom modules
- **Structure**: Follow modular approach - separate concerns into individual .nix files
- **Naming**: Use kebab-case for file names, camelCase for attribute names
- **Comments**: Use `#` for comments, document complex configurations
- **Secrets**: Never commit sensitive data, use environment variables or external secret management

## Project Structure
- `flake.nix` - Main flake configuration with desktop/laptop outputs
- `configuration.nix` - System-wide NixOS configuration
- `home.nix` - Home-manager entry point
- `modules/` - Modular configuration files (git, fish, languages, etc.)
- `hosts/` - Host-specific configurations (desktop/laptop)

## Important Notes
- **DO NOT RUN COMMANDS** - This is a declarative configuration, not imperative
- Use stateVersion consistently across configurations
- Test changes with `nixos-rebuild build` before switching
- Git integration configured with delta diff viewer and lazygit