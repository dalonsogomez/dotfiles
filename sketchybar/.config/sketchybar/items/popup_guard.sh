#!/usr/bin/env bash

popup_guard=(
  drawing=off
  updates=on
  script="$PLUGIN_DIR/popup_guard.sh"
)

sketchybar --add item popup_guard q \
           --set popup_guard "${popup_guard[@]}" \
           --subscribe popup_guard mouse.exited.global front_app_switched space_change display_change system_woke
