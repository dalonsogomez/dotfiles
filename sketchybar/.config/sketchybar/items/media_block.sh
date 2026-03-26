#!/bin/bash

source "$ITEM_DIR/battery.sh"
source "$ITEM_DIR/wifi.sh"
source "$ITEM_DIR/volume.sh"

media_block=(
  background.color="$ITEM_BG_COLOR"
  background.corner_radius=5
  background.padding_left=0
  background.padding_right=0
  background.height=20
  blur_radius=0
)

sketchybar --add bracket media_block battery wifi volume_icon \
           --set media_block "${media_block[@]}"
