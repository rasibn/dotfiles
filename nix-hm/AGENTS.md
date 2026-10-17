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
- Keep persistent configuration declarative. Do not replace Nix configuration with imperative installs, hand-edited generated files, or temporary service overrides.
- Read-only inspection and requested reloads/restarts are allowed. Build and switch commands above are references; run them when requested, without repeating approval already given in the session.
- Use stateVersion consistently across configurations
- When asked to build or switch, build the relevant host before activating changes. Do not claim a configuration was built or activated unless it actually was.
- Git integration configured with delta diff viewer and lazygit

## Lessons From Desktop Configuration Work

### Follow the existing Home Manager ownership pattern

- Inspect `modules/environment.nix` before adding application config wiring. This repository uses `config.lib.file.mkOutOfStoreSymlink` for editable dotfiles under `desktop/` and `shared/`.
- Add editable application configs there, pointing to the repository file or directory. Do not use `builtins.readFile` or inline `extraConfig` when the user wants the same live symlink pattern as the other apps.
- Keep service enablement in `modules/services.nix`. Inspect the installed Home Manager module before combining a custom symlink with a service module: generated `text`, `settings`, or `extraConfig` can claim the same destination.
- For Mako, the intended split is `services.mako.enable = true` plus the out-of-store config symlink in `environment.nix`; do not reintroduce a generated Mako config.
- Do not edit `/nix/store` or replace Home Manager's generated links by hand. Explain when a Nix switch is still needed versus when an application reload is sufficient.
- New files referenced as flake source inputs must be included in the flake's Git source before a build can see them. Check tracking status; do not stage unrelated changes.

### Manage the actual running service

- Identify the running application first. This session used Mako, not Dunst; do not infer the daemon from the user's recollection.
- Nix wrappers change process names: Waybar can appear as `.waybar-wrapped`, Mako as `.mako-wrapped`, and Ghostty's process name may be truncated. `pgrep -x waybar` can miss the running bar. Inspect executable names and arguments before terminating anything.
- Prefer the existing user service for service-managed programs. Do not stop a managed service and leave an unmanaged replacement running as the final result.
- Avoid runtime systemd drop-ins for previews unless needed. If used, record the exact file, explain its lifetime, and remove it when persistent wiring is applied; otherwise it can mask the real service configuration.
- Restart sequentially: stop the identified instance, confirm it exited, start one replacement, and confirm only one instance exists. Do not launch a second bar because a name lookup returned no match.
- Use the compositor/session environment when launching Wayland applications. A process starting or exiting with status zero does not establish that its UI appeared. Inspect logs and layer surfaces if necessary.

### Verify what the user can see

- Do not say "fixed", "applied", or "verified" based only on writing a file or starting a process. Distinguish saved configuration, active runtime state, and persistence after login.
- When the user requests visual verification, take and inspect a fresh screenshot after the reload. A theme parser accepting a file does not prove its layout is correct.
- Check startup logs for CSS, Rasi, and Pango errors. `alpha="0%"` broke the Waybar app list in this session. Use markup accepted by the installed Pango version and inspect the rendered result.
- Focus indicators must reserve identical space in active and inactive states. Avoid inserting/removing glyphs or changing font weight if that shifts labels or the bar's width.
- Explicitly constrain decorative Rofi widgets so they cannot consume the launcher height. A decorative heading previously left a large empty area above the search field.
- Determine backend and namespace from the installed application and live session before adding Niri layer rules. Keep text opaque when making surfaces translucent.
- When asked to check shortcuts, inspect the current bindings and lock-key state first. Explain exactly what changed; do not present newly added aliases as proof of the original cause.

### Preserve user choices and unrelated work

- Preserve intentional window widths, existing keybindings, and application preferences unless the requested change includes them. Describe Niri's distinction between columns, stacked windows, and workspaces before remapping navigation.
- Keep visual changes small and reviewable. Use an inspected reference when asked for an existing theme; do not repeatedly invent palettes or equate pink with purple.
- Do not broaden a desktop theme change into terminal or browser changes without authorization. Do not add managed browser policies just to change a color.
- Preserve staged and unstaged work from the user and other sessions. Revert only changes you own; avoid blanket file restores when unrelated edits may be present.
- Treat wallpapers as local assets according to the repository's ignore rules. Verify downloaded image dimensions directly; a resized preview or an "original" URL does not establish native resolution or artist provenance.
