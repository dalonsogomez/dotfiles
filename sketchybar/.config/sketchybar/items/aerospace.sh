#!/bin/bash

# Workspace indicator fed by AeroSpace custom event
sketchybar --add item aerospace_ws left \
           --set aerospace_ws icon="󰆍" \
                             label="WS" \
                             icon.color=$ACCENT_COLOR \
                             label.color=$ACCENT_COLOR \
                             background.drawing=off \
                             script="$PLUGIN_DIR/aerospace.sh" \
           --subscribe aerospace_ws aerospace_workspace_change
