#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
root=$(cd "$(dirname "$0")" && pwd)
for binary in paneru sketchybar borders python3; do
  command -v "$binary" >/dev/null || { echo "Install dependencies with: just install-gui-macos"; exit 1; }
done
backup="$HOME/.config/paneru-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$HOME/.config"
for name in paneru sketchybar borders; do
  target="$HOME/.config/$name"
  [ "$(readlink "$target" 2>/dev/null || true)" = "$root/$name" ] && continue
  if [ -e "$target" ] || [ -L "$target" ]; then
    mkdir -p "$backup"
    mv "$target" "$backup/$name"
  fi
  ln -s "$root/$name" "$target"
done
# Separate Spaces is required by Paneru; macOS applies this after logout.
defaults write com.apple.spaces spans-displays -bool false
# SketchyBar occupies the top 40px; reveal the native menu bar by hovering.
defaults write NSGlobalDomain _HIHideMenuBar -bool true
if [ -f "$HOME/Library/LaunchAgents/com.github.karinushka.paneru.plist" ]; then
  paneru restart
else
  paneru install
  paneru start
fi
brew services restart felixkratz/formulae/sketchybar
brew services restart felixkratz/formulae/borders
# Register event-driven workspace highlights (no polling delay).
agent="$HOME/Library/LaunchAgents/local.paneru.sketchybar-events.plist"
cat > "$agent" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>Label</key><string>local.paneru.sketchybar-events</string>
<key>ProgramArguments</key><array><string>/bin/bash</string><string>$HOME/.config/sketchybar/plugins/paneru-events.sh</string></array>
<key>RunAtLoad</key><true/><key>KeepAlive</key><true/>
<key>ThrottleInterval</key><integer>5</integer>
</dict></plist>
EOF
launchctl bootout "gui/$(id -u)/local.paneru.sketchybar-events" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$agent"
printf '%s\n' 'Enable Paneru in System Settings > Privacy & Security > Accessibility if prompted.' 'Log out and back in when convenient to apply separate Spaces.'
