# dotfiles — MacBook Pro 14" M5 Pro

Dotfiles for macOS adapted for **MacBook Pro 14" M5 Pro** (Apple Silicon ARM64).

## Stack

| Component | Tool |
|---|---|
| Window manager | AeroSpace |
| Terminal | Ghostty (primary) · WezTerm · Alacritty |
| Shell | Zsh + oh-my-zsh + Starship |
| Editor | Neovim (lazy.nvim) |
| Multiplexer | tmux + TPM |
| Status bar | Sketchybar |
| Key remapping | Karabiner-Elements |
| Shell history | Atuin |
| Music player | MPD + rmpc |
| File manager | Yazi (tmux popup) |
| Session manager | sesh |

## Install

```bash
# Prerequisites
xcode-select --install
git clone https://github.com/dalonsogomez/dotfiles.git $HOME/dotfiles

# Run install script
cd $HOME/dotfiles
chmod +x install.sh
/bin/bash install.sh
```

## Post-install

```bash
brew services start sketchybar          # start status bar
# Open tmux → <prefix> + I             # install tmux plugins (TPM)
# Open nvim                             # lazy.nvim auto-installs
# Inside nvim: :Mason                  # install LSP servers
```

## Adaptations from original (Sin-cy/dotfiles)

| File | Change |
|---|---|
| `zsh/.zprofile` | Removed `/Users/personal` hardcoded paths → `$HOME`. Guards for Deno, bun, Console Ninja. |
| `zsh/.zshrc` | Removed `/Users/personal` paths. Guards for `but` (GitButler) and `wtp` so shell doesn't error if not installed. |
| `sketchybar/plugins/wifi.sh` | Replaced `airport` CLI (removed in macOS Sequoia) with `networksetup -getairportnetwork en0`. |
| `install.sh` | Removed deprecated `homebrew/cask-fonts` tap. Added all missing deps (`ghostty`, `sketchybar`, `atuin`, `sesh`, `gum`, `yazi`, `switchaudio-osx`, `imagemagick`, `mpd`, etc). TPM cloned to correct path. Full stow of all packages. |
| `nvim/lua/sethy/lazy.lua` | `vim.loop.fs_stat` → `vim.uv.fs_stat` (deprecation fix, Neovim ≥ 0.10). |
| `nvim/lua/sethy/plugins/snacks.lua` | Removed hardcoded `~/Desktop/Others/profile.png` from dashboard. Dashboard image section commented with instructions. |

## Hardware

MacBook Pro 14" M5 Pro (2026) · Space Black · 64 GB unified memory · 1 TB SSD · macOS Sequoia+
