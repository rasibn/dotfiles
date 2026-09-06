# Dotfiles

- `dotfiles` for PC, macOS, Termux, Arch, and more

## Folder Structure

- `shared`: contains files that are universal in terminal environment
- `desktop`: contains files relating to GUI Environment for i3 and sway mostly.
- `windows`: contains Komorebi and AutoHotkey configuration.
- `config.env`: contains environment variables.

## Install Instruction

- Refer to the `justfile` for Unix install instructions.
- On Windows, run `just --justfile windows/justfile setup`.

## NixOS

- NixOS/Home Manager configuration is in [`nix-hm/`](nix-hm/).
- credits to [XNM1](https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles) for the nix config!
