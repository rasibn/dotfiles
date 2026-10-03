#!/bin/bash
# SketchyBar supplies the current output volume on volume_change.
if [[ "${INFO:-}" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  sketchybar --set "$NAME" "label=${INFO%.*}%"
fi
