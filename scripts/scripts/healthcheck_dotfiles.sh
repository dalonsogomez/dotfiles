#!/usr/bin/env bash
set -u

ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"
AERO="$ROOT/aerospace/.config/aerospace/aerospace.toml"
SKETCHY="$ROOT/sketchybar/.config/sketchybar/sketchybarrc"
KARA="$ROOT/karabiner/.config/karabiner/karabiner.json"
STAR="$ROOT/starship/.config/starship/starship.toml"
ZSHRC="$ROOT/zsh/.zshrc"

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

pass() { printf "PASS  %s\n" "$1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail() { printf "FAIL  %s\n" "$1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }
warn() { printf "WARN  %s\n" "$1"; WARN_COUNT=$((WARN_COUNT + 1)); }

require_file() {
  local file="$1"
  local desc="$2"
  if [ -f "$file" ]; then
    pass "$desc"
  else
    fail "$desc (missing: $file)"
  fi
}

run_check() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    pass "$desc"
  else
    fail "$desc"
  fi
}

run_warn() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    pass "$desc"
  else
    warn "$desc"
  fi
}

echo "=== Dotfiles Healthcheck ==="
echo "Root: $ROOT"
echo

# 0) Base files
require_file "$AERO" "AeroSpace config exists"
require_file "$SKETCHY" "SketchyBar config exists"
require_file "$KARA" "Karabiner config exists"
require_file "$STAR" "Starship config exists"
require_file "$ZSHRC" "Zsh config exists"

# 1) Syntax/parse checks
run_check "zsh syntax is valid" zsh -n "$ZSHRC"
run_check "starship config parses" env STARSHIP_CONFIG="$STAR" starship print-config
run_check "karabiner.json is valid JSON" jq empty "$KARA"

if bash -n "$SKETCHY" >/dev/null 2>&1; then
  pass "sketchybarrc syntax is valid"
else
  fail "sketchybarrc syntax is valid"
fi

if find "$ROOT/sketchybar/.config/sketchybar/items" -type f -name '*.sh' -print0 2>/dev/null | xargs -0 -I{} bash -n '{}' >/dev/null 2>&1; then
  pass "SketchyBar item scripts syntax is valid"
else
  fail "SketchyBar item scripts syntax is valid"
fi

if find "$ROOT/sketchybar/.config/sketchybar/plugins" -type f -name '*.sh' -print0 2>/dev/null | xargs -0 -I{} bash -n '{}' >/dev/null 2>&1; then
  pass "SketchyBar plugin scripts syntax is valid"
else
  fail "SketchyBar plugin scripts syntax is valid"
fi

# 2) Keyboard correctness for your case
if rg -q "alt-o\s*=\s*\['workspace O'" "$AERO"; then
  pass "AeroSpace notes workspace remains on Alt+O"
else
  fail "AeroSpace notes workspace remains on Alt+O"
fi

if rg -q "alt-shift-o\s*=\s*'move-node-to-workspace O'" "$AERO"; then
  pass "AeroSpace move-to-notes remains on Alt+Shift+O"
else
  fail "AeroSpace move-to-notes remains on Alt+Shift+O"
fi

if rg -q '"input_content": "ñ"' "$KARA" && rg -q '"input_content": "Ñ"' "$KARA"; then
  pass "Karabiner keeps Option+N => ñ and Shift+Option+N => Ñ"
else
  fail "Karabiner keeps Option+N => ñ and Shift+Option+N => Ñ"
fi

if jq -e '.profiles[] | select(.selected==true) | .complex_modifications.rules[] | select(.description=="Hyper Key (⌃⌥⇧⌘)") | [.manipulators[] | select(.from.key_code=="caps_lock")] | length == 1' "$KARA" >/dev/null 2>&1; then
  pass "Karabiner has one stable Caps Lock hyper manipulator"
else
  fail "Karabiner has one stable Caps Lock hyper manipulator"
fi

# 3) AeroSpace binding collisions by mode
if python3 - "$AERO" >/dev/null 2>&1 <<'PY'
import re,sys
p=sys.argv[1]
mode='main'
keys={}
mode_re=re.compile(r'^\[mode\.([^.]+)\.binding\]')
bind_re=re.compile(r'^([a-z0-9-]+)\s*=')
for i,l in enumerate(open(p, encoding='utf-8'),1):
    s=l.strip()
    m=mode_re.match(s)
    if m:
        mode=m.group(1)
        continue
    if not s or s.startswith('#'):
        continue
    b=bind_re.match(s)
    if b:
        k=b.group(1)
        if k == 'run':
            continue
        keys.setdefault((mode,k),[]).append(i)

dups=[(m,k,ls) for (m,k),ls in keys.items() if len(ls)>1]
if dups:
    raise SystemExit(1)
PY
then
  pass "AeroSpace has no duplicate key binding per mode"
else
  fail "AeroSpace has no duplicate key binding per mode"
fi

if rg -q "^b = \['layout tiles', 'flatten-workspace-tree', 'balance-sizes', 'mode main'\] # fit current workspace" "$AERO"; then
  pass "AeroSpace service mode keeps workspace fit shortcut (b)"
else
  fail "AeroSpace service mode keeps workspace fit shortcut (b)"
fi

# 4) SketchyBar desired state
if rg -q 'source "\$ITEM_DIR/workspace_fit.sh"' "$SKETCHY" && rg -q 'source "\$ITEM_DIR/display_mode.sh"' "$SKETCHY"; then
  pass "SketchyBar loads display_mode + workspace_fit"
else
  fail "SketchyBar loads display_mode + workspace_fit"
fi

if ! rg -q 'apps_quick\.sh|app\.chatgpt|app\.claude|app\.codex|app\.buho|app\.dropover' "$ROOT/sketchybar/.config/sketchybar"; then
  pass "SketchyBar app quick launchers are removed"
else
  fail "SketchyBar app quick launchers are removed"
fi

if ! rg -q 'mouse\.clicked\.global' "$ROOT/sketchybar/.config/sketchybar/items/popup_guard.sh" "$ROOT/sketchybar/.config/sketchybar/plugins/popup_guard.sh"; then
  pass "SketchyBar popup guard avoids unsupported mouse.clicked.global"
else
  fail "SketchyBar popup guard avoids unsupported mouse.clicked.global"
fi

if [ -x "$ROOT/sketchybar/.config/sketchybar/items/workspace_fit.sh" ] && [ -x "$ROOT/sketchybar/.config/sketchybar/plugins/workspace_fit.sh" ]; then
  pass "workspace_fit scripts are executable"
else
  fail "workspace_fit scripts are executable"
fi

# 5) Performance-oriented checks
if ! rg -q '^right_format\s*=\s*"""' "$STAR" && rg -q '^scan_timeout\s*=\s*60$' "$STAR" && rg -q '^command_timeout\s*=\s*300$' "$STAR"; then
  pass "Starship uses balanced performance profile"
else
  fail "Starship uses balanced performance profile"
fi

if rg -q '^command -v starship .*\$\(starship init zsh\)' "$ZSHRC" \
  && rg -q '^command -v fzf .*\$\(fzf --zsh\)' "$ZSHRC" \
  && rg -q '^command -v atuin .*\$\(atuin init zsh\)' "$ZSHRC"; then
  pass "Zsh init commands are guarded"
else
  fail "Zsh init commands are guarded"
fi

# 6) Runtime checks (best effort)
if command -v sketchybar >/dev/null 2>&1; then
  if sketchybar --reload >/dev/null 2>&1; then
    pass "SketchyBar reload succeeds"
  else
    warn "SketchyBar reload could not be verified (service may not be active)"
  fi
else
  warn "sketchybar binary not found in PATH"
fi

if command -v aerospace >/dev/null 2>&1; then
  if aerospace reload-config >/dev/null 2>&1; then
    pass "AeroSpace reload succeeds"
  else
    warn "AeroSpace reload could not be verified (app may not be running)"
  fi
else
  warn "aerospace binary not found in PATH"
fi

if command -v ps >/dev/null 2>&1; then
  if ps -Ao pid,pcpu,pmem,comm >/tmp/dotfiles_health_ps.$$ 2>/dev/null; then
    if rg -qi 'sketchybar|aerospace|karabiner' /tmp/dotfiles_health_ps.$$; then
      pass "Process snapshot collected for sketchybar/aerospace/karabiner"
    else
      warn "Process snapshot collected but target processes not detected"
    fi
    rm -f /tmp/dotfiles_health_ps.$$
  else
    warn "Process snapshot not permitted in this shell"
  fi
else
  warn "ps command not available"
fi

echo
echo "=== Summary ==="
echo "PASS: $PASS_COUNT"
echo "WARN: $WARN_COUNT"
echo "FAIL: $FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
