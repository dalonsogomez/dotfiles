#!/bin/bash

front_app=(
  background.drawing=off
  icon.drawing=off
  label.max_chars=18
  label.padding_left=8
  label.padding_right=10
  click_script="$PLUGIN_DIR/close_popups.sh"
  script="$PLUGIN_DIR/front_app.sh"
)

sketchybar --add item front_app left \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched
