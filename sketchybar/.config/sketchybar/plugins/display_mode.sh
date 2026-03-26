#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$CONFIG_ROOT/colors.sh"

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/display_mode.state"
WS_ALL=("1" "2" "3" "4" "5" "8" "9" "B" "F" "M" "O" "T")
WS_SECONDARY=("B" "M" "T")

mkdir -p "$(dirname "$STATE_FILE")"

read_state() {
  if [ -f "$STATE_FILE" ]; then
    cat "$STATE_FILE"
  else
    echo "auto"
  fi
}

write_state() {
  printf '%s\n' "$1" > "$STATE_FILE"
}

monitor_count() {
  local count
  count="$(aerospace list-monitors --count 2>/dev/null | tr -dc '0-9')"
  if [ -z "$count" ]; then
    count=1
  fi
  echo "$count"
}

is_secondary_workspace() {
  local ws="$1"
  local candidate
  for candidate in "${WS_SECONDARY[@]}"; do
    if [ "$candidate" = "$ws" ]; then
      return 0
    fi
  done
  return 1
}

move_ws() {
  local ws="$1"
  local monitor="$2"
  aerospace move-workspace-to-monitor --workspace "$ws" "$monitor" >/dev/null 2>&1 || true
}

apply_single() {
  local ws
  for ws in "${WS_ALL[@]}"; do
    move_ws "$ws" main
  done
}

apply_dual() {
  local count="$1"
  local ws
  local secondary_target="secondary"

  if [ "$count" -lt 2 ]; then
    apply_single
    return
  fi

  # AeroSpace documents 'secondary' specifically for two-monitor setups.
  # For 3+ monitors we pin secondary workspaces to monitor 2.
  if [ "$count" -gt 2 ]; then
    secondary_target="2"
  fi

  for ws in "${WS_ALL[@]}"; do
    if is_secondary_workspace "$ws"; then
      move_ws "$ws" "$secondary_target"
    else
      move_ws "$ws" main
    fi
  done
}

render_state() {
  local desired="$1"
  local count="$2"
  local label=""

  case "$desired" in
    auto) label="A${count}" ;;
    single) label="1P" ;;
    dual)
      if [ "$count" -ge 2 ]; then
        label="2P"
      else
        label="2P·1"
      fi
      ;;
    *) label="A${count}" ;;
  esac

  sketchybar --set display_mode icon.color="$ACCENT_COLOR" \
                          label.color="$ACCENT_COLOR" \
                          label="$label"
}

main() {
  local action="${1:-refresh}"
  local desired
  local count

  desired="$(read_state)"

  case "$action" in
    auto|single|dual)
      desired="$action"
      write_state "$desired"
      ;;
    refresh)
      ;;
    *)
      desired="auto"
      write_state "$desired"
      ;;
  esac

  count="$(monitor_count)"

  case "$desired" in
    auto)
      if [ "$count" -ge 2 ]; then
        apply_dual "$count"
      else
        apply_single
      fi
      ;;
    single)
      apply_single
      ;;
    dual)
      apply_dual "$count"
      ;;
  esac

  render_state "$desired" "$count"

  if [ "$action" != "refresh" ]; then
    "$SCRIPT_DIR/close_popups.sh" >/dev/null 2>&1 || true
  fi
}

main "$@"
