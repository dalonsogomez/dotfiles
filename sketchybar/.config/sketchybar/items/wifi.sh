#!/bin/bash

wifi=(
    script="$PLUGIN_DIR/wifi.sh"
    click_script="$PLUGIN_DIR/open_network_settings.sh"
    icon=$WIFI_CONNECTED
    label.drawing=off
    background.color="$PURE_BLACK"
    icon.font="$FONT:Regular:17.0"
    icon.align=center
    icon.padding_left=8
    icon.padding_right=8
    padding_left=0
    padding_right=0
    background.drawing=off
    icon.color=0xff58d1fc
    update_freq=20
    updates=when_shown
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}"
