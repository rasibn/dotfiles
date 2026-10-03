# macOS desktop

This setup uses Paneru for window management, SketchyBar for the menu bar, and
Borders for window outlines. The configuration is adapted from
[emreekici3/dotfiles](https://github.com/emreekici3/dotfiles).

Run `just install-gui-macos` to install the apps, then `just setup-gui-macos` to
link the configuration and start its services. Run `just setup-paneru` to
restart the Paneru, SketchyBar, and Borders services after editing their files.

The setup script links the configuration from this repository and starts
Paneru, SketchyBar, Borders, and the workspace update service. If a config
directory already exists, it is moved to `~/.config/paneru-backup-*` first.
The script enables separate display Spaces and auto-hides the native menu bar.
Enable Paneru under **System Settings → Privacy & Security → Accessibility** if
prompted. Log out and back in to apply the Spaces change.

See the [shortcut cheat sheet](shortcuts.md) for Paneru, Tinycast, Chrome, and
macOS keys. Paneru's Option+arrow bindings override macOS word navigation.

## Wallpaper

The optional [pixel aurora wallpaper](wallpapers/pixel-aurora.png) can be set in
**System Settings → Wallpaper → Add Photo → Choose File**.

## Launcher

Tinycast uses Command+Space for app launching. Set its **App Launcher** shortcut
and enable launch at login in Tinycast settings. Option+Space is Paneru's
floating-window shortcut.
