#!/usr/bin/env bash

CURRENT_WS=""
if command -v aerospace >/dev/null 2>&1; then
  CURRENT_WS="$(aerospace list-workspaces --focused 2>/dev/null | head -n1)"
elif [ -x /opt/homebrew/bin/aerospace ]; then
  CURRENT_WS="$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null | head -n1)"
fi

[ -z "$CURRENT_WS" ] && CURRENT_WS="?"

aerospace_ws=(
  icon="󰆍"
  label="$CURRENT_WS"
  icon.color=$ACCENT_COLOR
  label.color=$ACCENT_COLOR
  background.drawing=off
  script="$PLUGIN_DIR/aerospace_ws.sh"
)

sketchybar --add item aerospace_ws left \
           --set aerospace_ws "${aerospace_ws[@]}" \
           --subscribe aerospace_ws aerospace_workspace_change
