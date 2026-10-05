# Non-NixOS Linux Home Manager

This standalone Home Manager profile is for Debian. It is kept separate from
the NixOS Home Manager modules and NixOS system configuration, and expects the
dotfiles checkout at `~/assets/dotfiles`.

After installing Nix and Home Manager on the target system, run from this
repository:

```sh
nix --extra-experimental-features 'nix-command flakes' run github:nix-community/home-manager -- switch -b backup --flake ./nix-hm#rasib-debian
```

The profile installs user packages from the flake's pinned nixpkgs and uses
Home Manager to link the existing shell and app configs from `shared/`. Fish
is linked as-is; its contents are not translated into Home Manager options.

Home Manager does not remove equivalent apt packages. This profile includes
`fd`, `git`, `jq`, and `just`; check apt dependencies before removing any apt
packages that provide the same tools.
