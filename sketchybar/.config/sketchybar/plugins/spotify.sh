#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

trim() {
  local s="$1"
  local max="$2"
  if [ ${#s} -gt "$max" ]; then
    printf "%s…" "${s:0:$((max-1))}"
  else
    printf "%s" "$s"
  fi
}

split_payload() {
  local payload="$1"
  SRC="${payload%%|||*}"
  local rest="${payload#*|||}"
  TRACK="${rest%%|||*}"
  ARTIST="${rest#*|||}"
}

get_spotify() {
  osascript <<'APPLESCRIPT' 2>/dev/null
if application "Spotify" is running then
  tell application "Spotify"
    if player state is playing then
      return "spotify|||" & name of current track & "|||" & artist of current track
    end if
  end tell
end if
return ""
APPLESCRIPT
}

get_music() {
  osascript <<'APPLESCRIPT' 2>/dev/null
if application "Music" is running then
  tell application "Music"
    if player state is playing then
      return "music|||" & name of current track & "|||" & artist of current track
    end if
  end tell
end if
return ""
APPLESCRIPT
}

DATA=""

case "$SENDER" in
  spotify_playback_change|routine|"")
    DATA="$(get_spotify)"
    [ -z "$DATA" ] && DATA="$(get_music)"
    ;;
  *)
    DATA="$(get_spotify)"
    [ -z "$DATA" ] && DATA="$(get_music)"
    ;;
esac

if [ -z "$DATA" ]; then
  sketchybar --set "$NAME" icon="" icon.color="$GREY" label=""
  exit 0
fi

split_payload "$DATA"
TEXT="$(trim "$TRACK" 18)"
if [ -n "$ARTIST" ]; then
  TEXT="$TEXT · $(trim "$ARTIST" 12)"
fi

if [ "$SRC" = "spotify" ]; then
  ICON=""
  ICON_COLOR=0xff1db954
else
  ICON=""
  ICON_COLOR="$WHITE"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$ICON_COLOR" label="$TEXT"
