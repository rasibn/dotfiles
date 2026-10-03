#!/bin/bash
battery=$(pmset -g batt)
percentage=$(printf '%s' "$battery" | grep -Eo '[0-9]+%' | head -1)
[ -n "$percentage" ] || { sketchybar --set "$NAME" drawing=off; exit 0; }
icon=BAT
[[ "$battery" == *"AC Power"* ]] && icon=CHG
sketchybar --set "$NAME" drawing=on "icon=$icon" "label=$percentage"
