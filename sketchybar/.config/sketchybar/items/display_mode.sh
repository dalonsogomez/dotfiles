#!/usr/bin/env bash

display_mode=(
  icon="󰍹"
  label="A1"
  label.font="$FONT:Semibold:10.0"
  icon.padding_left=7
  icon.padding_right=4
  label.padding_left=0
  label.padding_right=7
  background.color="$ITEM_BG_COLOR"
  background.corner_radius=4
  click_script="$PLUGIN_DIR/display_mode_toggle.sh"
  script="$PLUGIN_DIR/display_mode.sh refresh"
  popup.align=left
  popup.y_offset=8
  popup.background.color=$POPUP_BACKGROUND_COLOR
  popup.background.border_color=$POPUP_BORDER_COLOR
  popup.background.border_width=1
  popup.background.corner_radius=8
)

sketchybar --add item display_mode left \
           --set display_mode "${display_mode[@]}" \
           --subscribe display_mode display_change system_woke

mode_item_style=(
  width=118
  icon.drawing=off
  label.align=left
  label.padding_left=10
  label.padding_right=10
  background.color=$POPUP_BACKGROUND_COLOR
)

sketchybar --add item display_mode.auto popup.display_mode \
           --set display_mode.auto "${mode_item_style[@]}" \
                                label="Auto (A1/A2)" \
                                click_script="$PLUGIN_DIR/display_mode.sh auto"

sketchybar --add item display_mode.single popup.display_mode \
           --set display_mode.single "${mode_item_style[@]}" \
                                  label="1 Pantalla" \
                                  click_script="$PLUGIN_DIR/display_mode.sh single"

sketchybar --add item display_mode.dual popup.display_mode \
           --set display_mode.dual "${mode_item_style[@]}" \
                                label="2 Pantallas" \
                                click_script="$PLUGIN_DIR/display_mode.sh dual"
