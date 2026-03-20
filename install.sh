#!/bin/bash

set -e

# ─── Xcode CLI Tools ─────────────────────────────────────────────────────────
if [[ "$(uname)" == "Darwin" ]]; then
    echo "macOS detected..."
    if xcode-select -p &>/dev/null; then
        echo "Xcode CLI tools already installed."
    else
        echo "Installing Xcode CLI tools..."
        xcode-select --install
        until xcode-select -p &>/dev/null; do sleep 5; done
    fi
fi

# ─── oh-my-zsh ───────────────────────────────────────────────────────────────
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "oh-my-zsh already installed — skipping."
else
    echo "Installing oh-my-zsh..."
    # KEEP_ZSHRC=yes → never overwrite existing .zshrc (stow will symlink ours)
    # RUNZSH=no      → don't launch zsh at the end of the installer
    KEEP_ZSHRC=yes RUNZSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ─── Homebrew ────────────────────────────────────────────────────────────────
if command -v brew &>/dev/null; then
    echo "Homebrew already installed — skipping."
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew analytics off
fi

# ─── Taps ────────────────────────────────────────────────────────────────────
echo "Tapping Brew..."
# NOTE: homebrew/cask-fonts was deprecated — do NOT tap it, fonts install directly.
brew tap FelixKratz/formulae   # sketchybar, borders
brew tap nikitabobko/tap       # aerospace

# ─── Core utils ──────────────────────────────────────────────────────────────
echo "Installing core utilities..."
brew install coreutils

# ─── CLI formulae ────────────────────────────────────────────────────────────
echo "Installing CLI formulae..."
brew install \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    stow \
    fzf \
    bat \
    fd \
    zoxide \
    lua \
    luajit \
    luarocks \
    prettier \
    make \
    ripgrep \
    eza \
    git \
    lazygit \
    tmux \
    neovim \
    starship \
    tree-sitter \
    tree \
    borders \
    atuin \
    sesh \
    gum \
    yazi \
    switchaudio-osx \
    imagemagick \
    sqlite \
    node \
    nvm \
    sketchybar

# ─── zsh-system-clipboard (not in Homebrew core) ─────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-system-clipboard" ]]; then
    echo "Cloning zsh-system-clipboard..."
    git clone https://github.com/kutsan/zsh-system-clipboard \
        "$ZSH_CUSTOM/plugins/zsh-system-clipboard" --quiet
fi

# ─── wtp (git worktree plus) — optional ──────────────────────────────────────
if ! command -v wtp &>/dev/null; then
    brew install satococoa/tap/wtp 2>/dev/null || \
        echo "wtp tap unavailable — install manually if needed."
fi

# ─── Casks ───────────────────────────────────────────────────────────────────
# Each cask is installed individually so that an already-present app
# (e.g. Ghostty installed manually) does not abort the whole script.
echo "Installing Casks..."

install_cask() {
    local cask="$1"
    if brew list --cask "$cask" &>/dev/null; then
        echo "  ✓ $cask already installed — skipping"
    else
        brew install --cask "$cask" || \
            brew install --cask --force "$cask" || \
            echo "  ⚠ Could not install $cask — install manually if needed"
    fi
}

install_cask ghostty
install_cask raycast
install_cask karabiner-elements
install_cask nikitabobko/tap/aerospace
install_cask keycastr
install_cask betterdisplay
install_cask linearmouse
install_cask font-jetbrains-mono-nerd-font
# NOTE: font-sf-pro ships with macOS Tahoe — no installation needed.

# ─── TPM — Tmux Plugin Manager ───────────────────────────────────────────────
# tmux.conf expects TPM at ~/.config/tmux/.tmux/plugins/tpm
TPM_PATH="$HOME/.config/tmux/.tmux/plugins/tpm"
if [[ ! -d "$TPM_PATH" ]]; then
    echo "Installing TPM..."
    mkdir -p "$(dirname "$TPM_PATH")"
    git clone https://github.com/tmux-plugins/tpm "$TPM_PATH" --quiet
fi

# ─── Neovim undo directory ───────────────────────────────────────────────────
mkdir -p "$HOME/.vim/undodir"

# ─── macOS defaults ──────────────────────────────────────────────────────────
echo "Applying macOS defaults..."
defaults write com.apple.Dock autohide -bool TRUE
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

csrutil status

# ─── Clone dotfiles ──────────────────────────────────────────────────────────
if [[ ! -d "$HOME/dotfiles" ]]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/dalonsogomez/dotfiles.git "$HOME/dotfiles"
fi

# ─── Export coreutils to PATH ────────────────────────────────────────────────
ZPROFILE="$HOME/.zprofile"
COREUTILS_LINE='export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"'
grep -qF "$COREUTILS_LINE" "$ZPROFILE" 2>/dev/null || \
    echo "$COREUTILS_LINE" >> "$ZPROFILE"

# ─── Pre-stow: remove real files that would conflict with symlinks ───────────
# stow cannot replace real files with symlinks unless they are removed first.
# We back them up before removing.
presow_remove() {
    local target="$HOME/$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "  Backing up $target → ${target}.bak"
        mv "$target" "${target}.bak"
    fi
}
presow_remove ".zshrc"
presow_remove ".zprofile"
presow_remove ".zshenv"

# ─── Stow all dotfiles packages ──────────────────────────────────────────────
echo "Stowing dotfiles..."
cd "$HOME/dotfiles" || exit 1
mkdir -p "$HOME/.config"

stow -t ~ \
    aerospace \
    atuin \
    ghostty \
    karabiner \
    nvim \
    scripts \
    sketchybar \
    starship \
    tmux \
    zed \
    zsh

# ─── Autostart services ──────────────────────────────────────────────────────
echo "Starting services..."
brew services start sketchybar

echo ""
echo "✓ Installation complete."
echo ""
echo "Run the post-install script to finish the interactive setup:"
echo ""
echo "  /bin/bash ~/dotfiles/post-install.sh"
echo ""
