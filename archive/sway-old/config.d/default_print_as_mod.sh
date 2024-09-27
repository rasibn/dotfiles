set $mod Print
# all the keybindings that use Print except for RESIZE AND shift + Print!!

## Key bindings
#
# Basics:
#
# Start a floating terminal
bindsym $mod+Return exec $term-float
bindsym $mod+Shift+Return exec $term-float -e tmux

# Open the power menu
bindsym $mod+Shift+e exec $powermenu

# Kill focused window
bindsym $mod+q kill

# Start your launcher
bindsym $mod+d exec $menu

# Emoji Picker
bindsym $mod+g exec rofi -modi emoji -show emoji

# Activities
# bindsym $mod+p exec ~/.config/wofi/windows.py
bindsym $mod+p exec 'rofi -show window -show-icons'

# Drag floating windows by holding down $mod and left mouse button.
# Resize them with right mouse button + $mod.
# Despite the name, also works for non-floating windows.
# Change normal to inverse to use left mouse button for resizing and right
# mouse button for dragging.
# floating_modifier $mod normal

# Reload the configuration file
bindsym $mod+Shift+r reload

#
# Moving around:
#
# Move your focus around
bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right
# Or use $mod+[up|down|left|right]
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# Move the focused window with the same, but add Shift
bindsym $mod+Shift+$left move left
bindsym $mod+Shift+$down move down
bindsym $mod+Shift+$up move up
bindsym $mod+Shift+$right move right
# Ditto, with arrow keys
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right
#
# Workspaces:
#
# Switch to workspace
bindsym $mod+1 workspace number 1
bindsym $mod+2 workspace number 2
bindsym $mod+3 workspace number 3
bindsym $mod+4 workspace number 4
bindsym $mod+5 workspace number 5

bindsym $mod+6 workspace number 1
bindsym $mod+7 workspace number 2
bindsym $mod+8 workspace number 3
bindsym $mod+9 workspace number 4
bindsym $mod+0 workspace number 5

# Move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
bindsym $mod+Shift+5 move container to workspace number 5

bindsym $mod+Shift+6 move container to workspace number 1
bindsym $mod+Shift+7 move container to workspace number 2
bindsym $mod+Shift+8 move container to workspace number 3
bindsym $mod+Shift+9 move container to workspace number 4
bindsym $mod+Shift+0 move container to workspace number 5

# Note: workspaces can have any name you want, not just numbers.
# We just use 1-10 as the default.
bindsym $mod+b splith
bindsym $mod+v splitv

# Switch the current container between different layout styles
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# Make the current focus fullscreen
bindsym $mod+Shift+f fullscreen

# Toggle the current focus between tiling and floating mode
bindsym $mod+Shift+space floating toggle

# Swap focus between the tiling area and the floating area
bindsym $mod+space focus mode_toggle

# Move focus to the container
bindsym $mod+a focus parent
bindsym $mod+z focus child
# Scratchpad:
#
# Sway has a "scratchpad", which is a bag of holding for windows.
# You can send windows there and get them back later.

# Move the currently focused window to the scratchpad
bindsym $mod+Shift+minus move scratchpad

# Show the next scratchpad window or hide the focused scratchpad window.
# If there are multiple scratchpad windows, this command cycles through them.
bindsym $mod+minus scratchpad show
#

# TODO: refactor to env variables instead of browser name
bindsym $mod+y exec vivaldi-stable
bindsym $mod+Shift+y exec vivaldi-stable https://youtube.com

bindsym $mod+u exec vivaldi-stable https:github.com
bindsym $mod+Shift+u exec vivaldi-stable http:://localhost:3000
# i need to bind anki and
bindsym $mod+o exec vivaldi-stable https://outlook.office.com/mail/inbox
bindsym $mod+Shift+o exec vivaldi-stable https://gmail.com

bindsym $mod+t exec vivaldi-stable https://ticktick.com/webapp/#q/all/habit
bindsym $mod+Shift+t exec vivaldi-stable https://www.notion.so

bindsym $mod+x exec vivaldi-stable https://chat.openai.com
bindsym $mod+Shift+x exec vivaldi-stable https://phind.com

#utlity row
bindsym $mod+n exec thunar
bindsym $mod+Shift+n exec code

bindsym $mod+m exec anki
bindsym $mod+Shift+m exec obsidian

# Screenshots
#
# bindsym print exec /usr/share/sway/scripts/grimshot --notify save output

# capture the specified screen area to clipboard
bindsym $mod+Shift+s exec grim -g "$(slurp)" - | wl-copy

#
# Keybindings List
#
bindsym $mod+c exec nvim ~/.config/sway/cheatsheet
