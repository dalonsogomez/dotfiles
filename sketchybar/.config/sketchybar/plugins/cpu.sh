#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

CORES="$(sysctl -n hw.ncpu 2>/dev/null)"
[ -z "$CORES" ] && CORES=1
USAGE=$(ps -A -o %cpu | awk -v cores="$CORES" 'NR>1{s+=$1} END { if (cores > 0) printf "%.0f", s/cores; else printf "%.0f", s }')
[ -z "$USAGE" ] && USAGE=0

if [ "$USAGE" -ge 80 ] 2>/dev/null; then
  COLOR="$RED"
elif [ "$USAGE" -ge 50 ] 2>/dev/null; then
  COLOR="$YELLOW"
else
  COLOR="$GREY"
fi

sketchybar --set "$NAME" label="${USAGE}%" icon.color="$COLOR"
