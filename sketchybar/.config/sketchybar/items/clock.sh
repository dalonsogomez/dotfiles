#!/bin/sh

clock=(
  background.drawing=off
  update_freq=30
  icon=
  icon.color=$ACCENT_COLOR
  click_script="$PLUGIN_DIR/open_calendar.sh"
  script="$PLUGIN_DIR/clock.sh"
)

sketchybar --add item clock right \
           --set clock "${clock[@]}"
