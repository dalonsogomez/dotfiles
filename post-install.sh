#!/bin/bash

# post-install.sh — interactive setup steps after install.sh
# Run this AFTER install.sh has completed.
# Usage: /bin/bash ~/dotfiles/post-install.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

separator() {
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────${RESET}"
}

header() {
    separator
    echo -e "${BOLD}  $1${RESET}"
    separator
}

done_step() {
    echo -e "  ${GREEN}✓${RESET} $1"
}

info_step() {
    echo -e "  ${YELLOW}→${RESET} $1"
}

echo ""
echo -e "${BOLD}  post-install.sh — MacBook Pro M5 Pro setup${RESET}"
echo ""
echo "  Este script completa la configuración interactiva."
echo "  Algunos pasos requieren tu intervención directa."

# ─── 1. Sketchybar ───────────────────────────────────────────────────────────
header "1/5  Sketchybar"

if brew services list | grep -q "sketchybar.*started"; then
    done_step "sketchybar ya está corriendo"
else
    echo "  Iniciando sketchybar..."
    brew services start sketchybar
    done_step "sketchybar iniciado"
fi

# ─── 2. Zsh plugins ──────────────────────────────────────────────────────────
header "2/5  Zsh plugins"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-system-clipboard" ]]; then
    echo "  Clonando zsh-system-clipboard..."
    git clone https://github.com/kutsan/zsh-system-clipboard \
        "$ZSH_CUSTOM/plugins/zsh-system-clipboard" --quiet
    done_step "zsh-system-clipboard instalado"
else
    done_step "zsh-system-clipboard ya presente"
fi

# ─── 3. Tmux plugins (TPM) ───────────────────────────────────────────────────
header "3/5  Tmux plugins (TPM)"

TPM="$HOME/.config/tmux/.tmux/plugins/tpm"

if [[ ! -d "$TPM" ]]; then
    echo "  Clonando TPM..."
    mkdir -p "$(dirname "$TPM")"
    git clone https://github.com/tmux-plugins/tpm "$TPM" --quiet
    done_step "TPM clonado"
else
    done_step "TPM ya presente"
fi

# Install plugins headlessly via TPM's install script
if [[ -f "$TPM/bin/install_plugins" ]]; then
    echo "  Instalando plugins de tmux..."
    # TPM install_plugins needs TMUX_PLUGIN_MANAGER_PATH set
    TMUX_PLUGIN_MANAGER_PATH="$HOME/.config/tmux/.tmux/plugins" \
        bash "$TPM/bin/install_plugins" 2>/dev/null && \
        done_step "Plugins de tmux instalados (catppuccin, resurrect, continuum, sessionx, etc.)" || \
        info_step "Instalación headless falló — abre tmux y presiona: Ctrl+b, luego I (mayúscula)"
else
    info_step "Abre tmux y presiona: Ctrl+b, luego I (mayúscula) para instalar plugins"
fi

# ─── 4. Neovim plugins ───────────────────────────────────────────────────────
header "4/5  Neovim — lazy.nvim + Mason LSP"

if ! command -v nvim &>/dev/null; then
    echo "  nvim no encontrado — instala con: brew install neovim"
else
    NVIM_VERSION=$(nvim --version | head -1)
    echo "  Detectado: $NVIM_VERSION"
    echo ""

    echo "  Instalando plugins de lazy.nvim en modo headless..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null && \
        done_step "Plugins de lazy.nvim instalados" || \
        info_step "Si falla, abre nvim normalmente — lazy.nvim instala al arrancar"

    echo ""
    echo "  Instalando LSP servers via Mason..."
    # Install the servers defined in mason.lua ensure_installed list
    MASON_SERVERS=(
        lua-language-server
        typescript-language-server
        html-lsp
        css-lsp
        tailwindcss-language-server
        gopls
        angular-language-server
        astro-language-server
        emmet-ls
        emmet-language-server
        marksman
        prettier
        stylua
        isort
        pylint
        clangd
        deno
    )

    nvim --headless \
        "+MasonInstall ${MASON_SERVERS[*]}" \
        "+lua vim.wait(120000, function() return false end)" \
        +qa 2>/dev/null && \
        done_step "Mason LSP servers instalados" || \
        info_step "Si falla, abre nvim y ejecuta :Mason para instalar manualmente"
fi

# ─── 5. Pasos manuales restantes ─────────────────────────────────────────────
header "5/5  Pasos manuales"

echo ""
info_step "AeroSpace: se inicia automáticamente al login (start-at-login = true)"
info_step "Karabiner: abre la app y acepta los permisos de accesibilidad si los pide"
info_step "Sketchybar + AeroSpace: descomenta en aerospace.toml para conectarlos:"
echo "          exec-on-workspace-change = ['/bin/bash', '-c',"
echo "            'sketchybar --trigger aerospace_workspace_change ...']"
echo ""
info_step "Dashboard de Neovim con imagen propia:"
echo "          Edita nvim/.config/nvim/lua/sethy/plugins/snacks.lua"
echo "          Descomenta la sección 'terminal' y pon la ruta de tu imagen"
echo "          Requiere: brew install ascii-image-converter"
echo ""
info_step "MPD (música):"
echo "          Añade música a ~/.config/mpd/music/"
echo "          brew services start mpd"
echo "          Abre rmpc con: Ctrl+b, luego Ctrl+m (dentro de tmux)"
echo ""
info_step "Raycast extensions (usadas en karabiner.json):"
echo "          - Toothpick (Bluetooth)"
echo "          - Color Picker"
echo "          - Do Not Disturb (yakitrak)"
echo "          - Folder Search (GastroGeek)"
echo "          - File Manager (erics118)"

separator
echo ""
echo -e "${GREEN}${BOLD}  ✓ post-install completado.${RESET}"
echo ""
echo "  Reinicia la sesión de zsh para cargar todos los cambios:"
echo ""
echo "    exec zsh"
echo ""
