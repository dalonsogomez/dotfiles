#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
"$SCRIPT_DIR/close_popups.sh" >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.Network-Settings.extension" >/dev/null 2>&1 || \
open -a "System Settings"
