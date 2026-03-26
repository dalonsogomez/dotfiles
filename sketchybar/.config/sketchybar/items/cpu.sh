#!/bin/bash

cpu=(
  icon=""
  icon.color=$GREY
  label="0%"
  background.drawing=off
  update_freq=15
  updates=when_shown
  click_script="$PLUGIN_DIR/open_activity_monitor.sh"
  script="$PLUGIN_DIR/cpu.sh"
)

sketchybar --add item cpu right \
           --set cpu "${cpu[@]}"
