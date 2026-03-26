#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

case "$SENDER" in
  mouse.exited.global|front_app_switched|space_change|display_change|system_woke)
    "$SCRIPT_DIR/close_popups.sh" >/dev/null 2>&1 || true
    ;;
esac
