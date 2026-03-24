#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$NAME" = "aerospace_ws" ] && [ "$SENDER" = "aerospace_workspace_change" ]; then
    WS="$FOCUSED_WORKSPACE"

    if [ -z "$WS" ] && [ -n "$INFO" ]; then
        WS="$INFO"
    fi

    if [ -z "$WS" ]; then
        WS="?"
    fi

    sketchybar --set "$NAME" label="$WS"
    exit 0
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME \
        background.drawing=on \
        icon.color=0xFF1E1E2E
else
    sketchybar --set $NAME \
        background.drawing=off \
        icon.color=0xFF8D93AF
fi
