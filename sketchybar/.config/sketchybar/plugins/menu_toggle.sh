#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
"$SCRIPT_DIR/close_popups.sh" >/dev/null 2>&1 || true
sketchybar --set menu_button popup.drawing=toggle
