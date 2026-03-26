#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

TARGET="${GIT_STATUS_PATH:-$HOME/dotfiles}"

if ! git -C "$TARGET" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  sketchybar --set "$NAME" label="" icon.color="$GREY"
  exit 0
fi

CHANGES=$(git -C "$TARGET" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
BRANCH=$(git -C "$TARGET" branch --show-current 2>/dev/null)

if [ -z "$CHANGES" ]; then CHANGES=0; fi

if [ "$CHANGES" -gt 0 ] 2>/dev/null; then
  sketchybar --set "$NAME" label="$CHANGES" icon.color="$YELLOW"
else
  sketchybar --set "$NAME" label="0" icon.color="$GREY"
fi

[ -n "$BRANCH" ] && sketchybar --set "$NAME" label="${CHANGES}"
