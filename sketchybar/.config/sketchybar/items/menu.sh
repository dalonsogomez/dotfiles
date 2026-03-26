#!/bin/bash

menu_button=(
  icon=""
  label.drawing=off
  background.drawing=off
  click_script="$PLUGIN_DIR/menu_toggle.sh"
  popup.align=left
  popup.y_offset=8
  popup.background.color=$POPUP_BACKGROUND_COLOR
  popup.background.border_color=$POPUP_BORDER_COLOR
  popup.background.border_width=1
  popup.background.corner_radius=8
)

sketchybar --add item menu_button left \
           --set menu_button "${menu_button[@]}"

menu_item_style=(
  width=170
  icon.padding_left=8
  label.padding_left=8
  label.align=left
  background.color=$POPUP_BACKGROUND_COLOR
)

sketchybar --add item menu.preferences popup.menu_button \
           --set menu.preferences "${menu_item_style[@]}" icon="" label="Preferences" \
           click_script="open -b com.apple.systempreferences || open -a 'System Settings'; $PLUGIN_DIR/close_popups.sh"

sketchybar --add item menu.activity popup.menu_button \
           --set menu.activity "${menu_item_style[@]}" icon="" label="Activity" \
           click_script="open -a 'Activity Monitor'; $PLUGIN_DIR/close_popups.sh"

sketchybar --add item menu.lock popup.menu_button \
           --set menu.lock "${menu_item_style[@]}" icon="" label="Lock Screen" \
           click_script="/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend; $PLUGIN_DIR/close_popups.sh"
