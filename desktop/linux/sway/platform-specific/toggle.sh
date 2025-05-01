#!/bin/bash

# Define monitor names
monitor_left="DP-1"
monitor_right="DP-3"

# Get current active outputs
active_outputs=$(swaymsg -t get_outputs | grep -c '"active": true')

if [ "$active_outputs" -eq "2" ]; then
  # Disable right monitor
  swaymsg output $monitor_right disable

  # Move all workspaces to the left monitor
  swaymsg workspace 1 output $monitor_left
  swaymsg workspace 2 output $monitor_left
  swaymsg workspace 3 output $monitor_left
  swaymsg workspace 4 output $monitor_left
  swaymsg workspace 5 output $monitor_left
else
  # Enable right monitor
  swaymsg output $monitor_right enable

  # Set up workspace distribution
  swaymsg workspace 1 output $monitor_left
  swaymsg workspace 2 output $monitor_left
  swaymsg workspace 3 output $monitor_left
  swaymsg workspace 4 output $monitor_left
  swaymsg workspace 5 output $monitor_left
  swaymsg workspace 6 output $monitor_right
  swaymsg workspace 7 output $monitor_right
  swaymsg workspace 8 output $monitor_right
  swaymsg workspace 9 output $monitor_right
  swaymsg workspace 10 output $monitor_right
fi
