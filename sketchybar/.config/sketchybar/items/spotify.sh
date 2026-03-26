#!/bin/bash

spotify=(
  icon=""
  icon.color=$GREY
  label.max_chars=26
  label.drawing=on
  background.drawing=off
  update_freq=20
  updates=when_shown
  click_script="$PLUGIN_DIR/spotify_click.sh"
  script="$PLUGIN_DIR/spotify.sh"
)

sketchybar --add item spotify right \
           --set spotify "${spotify[@]}" \
           --subscribe spotify spotify_playback_change
