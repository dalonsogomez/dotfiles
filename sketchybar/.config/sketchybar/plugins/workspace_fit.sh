#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if command -v aerospace >/dev/null 2>&1; then
  AEROSPACE_BIN="$(command -v aerospace)"
elif [ -x /opt/homebrew/bin/aerospace ]; then
  AEROSPACE_BIN="/opt/homebrew/bin/aerospace"
else
  exit 0
fi

CURRENT_WS="$($AEROSPACE_BIN list-workspaces --focused 2>/dev/null | head -n1)"
if [ -n "$CURRENT_WS" ]; then
  $AEROSPACE_BIN workspace "$CURRENT_WS" >/dev/null 2>&1 || true
fi

# Workspace visual reset for current desktop
$AEROSPACE_BIN layout tiles >/dev/null 2>&1 || \
$AEROSPACE_BIN layout tiles horizontal vertical >/dev/null 2>&1 || true
$AEROSPACE_BIN flatten-workspace-tree >/dev/null 2>&1 || true
$AEROSPACE_BIN balance-sizes >/dev/null 2>&1 || true

"$SCRIPT_DIR/close_popups.sh" >/dev/null 2>&1 || true
