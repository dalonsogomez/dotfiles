#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

get_wifi_device() {
  if ifconfig en0 >/dev/null 2>&1; then
    printf "en0"
    return
  fi

  networksetup -listallhardwareports 2>/dev/null | awk '
    BEGIN { IGNORECASE = 1 }
    /^Hardware Port: (Wi-Fi|AirPort)$/ { want = 1; next }
    want && /^Device: / { print $2; exit }
  '
}

is_disconnected_output() {
  printf "%s" "$1" | tr '[:upper:]' '[:lower:]' | grep -Eq \
    'not associated|no (esta|está) asociado|not a wi-fi interface|error obtaining wireless information'
}

WIFI_DEV="$(get_wifi_device)"
RAW_OUTPUT=""
SSID=""
STATE=""
IP_ADDR=""

if [ -n "$WIFI_DEV" ]; then
  RAW_OUTPUT="$(networksetup -getairportnetwork "$WIFI_DEV" 2>&1)"
  SSID="$(printf "%s\n" "$RAW_OUTPUT" | awk -F': ' 'NF>1{print $NF}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | head -n1)"
  STATE="$(ifconfig "$WIFI_DEV" 2>/dev/null | awk '/status:/{print $2; exit}')"
  IP_ADDR="$(ipconfig getifaddr "$WIFI_DEV" 2>/dev/null)"
fi

if [ -n "$WIFI_DEV" ] && [ "$STATE" = "active" ] && [ -n "$IP_ADDR" ]; then
  sketchybar --set "$NAME" icon="$WIFI_CONNECTED" icon.color=0xff58d1fc label=""
elif [ -z "$WIFI_DEV" ] || is_disconnected_output "$RAW_OUTPUT"; then
  sketchybar --set "$NAME" icon="$WIFI_DISCONNECTED" icon.color="$RED" label=""
elif [ -n "$SSID" ]; then
  sketchybar --set "$NAME" icon="$WIFI_CONNECTED" icon.color=0xff58d1fc label=""
else
  if [ "$STATE" = "active" ]; then
    sketchybar --set "$NAME" icon="$WIFI_CONNECTED" icon.color=0xff58d1fc label=""
  else
    sketchybar --set "$NAME" icon="$WIFI_DISCONNECTED" icon.color="$RED" label=""
  fi
fi
