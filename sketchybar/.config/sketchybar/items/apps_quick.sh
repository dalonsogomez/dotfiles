#!/usr/bin/env bash

APP_ITEMS=()

add_app_launcher() {
  local key="$1"
  local bundle_id="$2"
  local app_name="$3"

  local item="app.${key}"
  local launcher=(
    icon.drawing=off
    label.drawing=off
    width=20
    padding_left=2
    padding_right=2
    background.drawing=on
    background.color=0x00000000
    background.height=16
    background.corner_radius=3
    background.image="app.${bundle_id}"
    background.image.scale=0.66
    background.image.drawing=on
    click_script="$PLUGIN_DIR/close_popups.sh; open -b ${bundle_id} >/dev/null 2>&1 || open -a '${app_name}'"
  )

  sketchybar --add item "$item" left \
             --set "$item" "${launcher[@]}"
  APP_ITEMS+=("$item")
}

add_app_launcher "chatgpt" "com.openai.chat" "ChatGPT"
add_app_launcher "claude" "com.anthropic.claudefordesktop" "Claude"
add_app_launcher "codex" "com.openai.codex" "Codex"
add_app_launcher "buho" "com.drbuho.BuhoCleaner" "BuhoCleaner"

sketchybar --add bracket apps_quick "${APP_ITEMS[@]}" \
           --set apps_quick background.drawing=off
