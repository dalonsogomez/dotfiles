#!/bin/bash

# airport was removed in macOS Sequoia (15+). Using networksetup instead.
SSID=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' '{print $2}')

if [[ -z "$SSID" || "$SSID" == *"not associated"* ]]; then
    SSID=""
fi

sketchybar --set wifi \
    icon= \
    icon.color=0xff39FF14 \
    icon.align=center \
    label="$SSID"
