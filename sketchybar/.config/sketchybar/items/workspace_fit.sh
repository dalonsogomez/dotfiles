#!/usr/bin/env bash

workspace_fit=(
  icon="󰧟"
  label="Fit"
  icon.color=$ACCENT_COLOR
  label.color=$ACCENT_COLOR
  background.color="$ITEM_BG_COLOR"
  background.corner_radius=4
  padding_left=2
  padding_right=2
  click_script="$PLUGIN_DIR/workspace_fit.sh"
)

sketchybar --add item workspace_fit left \
           --set workspace_fit "${workspace_fit[@]}"
