#!/usr/bin/env bash

WS="$FOCUSED_WORKSPACE"
[ -z "$WS" ] && WS="$INFO"

if [ -z "$WS" ]; then
  if command -v aerospace >/dev/null 2>&1; then
    WS="$(aerospace list-workspaces --focused 2>/dev/null | head -n1)"
  elif [ -x /opt/homebrew/bin/aerospace ]; then
    WS="$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null | head -n1)"
  fi
fi

[ -z "$WS" ] && WS="?"

sketchybar --set "$NAME" label="$WS"
