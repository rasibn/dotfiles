#
# ~/.bash_profile
#

# Source .bashrc for login shells
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Autostart Hyprland on TTY1
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    start-hyprland
fi
