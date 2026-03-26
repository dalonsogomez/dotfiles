#!/usr/bin/env bash

popup_state="$(sketchybar --query display_mode 2>/dev/null | tr -d '[:space:]')"
if echo "$popup_state" | grep -q '"popup":{"drawing":"on"'; then
  sketchybar --set display_mode popup.drawing=off
else
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  "$SCRIPT_DIR/close_popups.sh" >/dev/null 2>&1 || true
  sketchybar --set display_mode popup.drawing=on
fi
