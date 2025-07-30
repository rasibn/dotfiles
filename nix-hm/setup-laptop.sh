#!/bin/bash
set -e

sudo -v

echo '  nix.settings.experimental-features = ["nix-command" "flakes"];' | sudo tee -a /etc/nixos/configuration.nix
nixos-rebuild switch

mkdir -p ~/assets
cd ~/assets
git clone https://github.com/rasibn/dotfiles
cd dotfiles
cp /etc/nixos/hardware-configuration.nix .
rm -rf .config/hypr .config/fish 2>/dev/null || true
nixos-rebuild switch --flake ~/assets/dotfiles/nix-hm/#laptop
