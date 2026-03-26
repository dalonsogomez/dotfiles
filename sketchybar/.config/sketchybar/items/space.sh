#!/bin/bash

SPACE_IDS=("1" "2" "3" "4" "5" "8" "9" "B" "F" "M" "O" "T")
SPACE_ITEMS=()

for id in "${SPACE_IDS[@]}"; do
  case "$id" in
    B) icon="${WS_BROWSER:-B}" ;;
    F) icon="${WS_FINDER:-F}" ;;
    M) icon="${WS_MUSIC:-M}" ;;
    O) icon="${WS_NOTES:-O}" ;;
    T) icon="${WS_TERMINAL:-T}" ;;
    *) icon="$id" ;;
  esac

  space_item=(
    icon="$icon"
    icon.padding_left=6
    icon.padding_right=6
    icon.y_offset=1
    label.drawing=off
    background.color="$BACKGROUND_2"
    background.corner_radius=2
    background.padding_left=4
    background.padding_right=4
    background.height=18
    icon.font="$FONT:Regular:13.0"
    drawing=on
    script="$CONFIG_DIR/plugins/aerospace.sh $id"
    click_script="$PLUGIN_DIR/close_popups.sh; aerospace workspace $id"
  )

  sketchybar --add item space.$id left \
             --set space.$id "${space_item[@]}" \
             --subscribe space.$id aerospace_workspace_change

  SPACE_ITEMS+=("space.$id")
done

sketchybar --add bracket workspaces "${SPACE_ITEMS[@]}" \
           --set workspaces background.color="$PURE_BLACK"
