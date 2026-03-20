# dotfiles — MacBook Pro 14" M5 Pro

Dotfiles para macOS adaptados para **MacBook Pro 14" M5 Pro** (Apple Silicon ARM64) corriendo **macOS Tahoe 26**.

---

## Instalación rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/dalonsogomez/dotfiles.git $HOME/dotfiles

# 2. Instalación automática
cd $HOME/dotfiles
chmod +x install.sh
/bin/bash install.sh

# 3. Setup interactivo (plugins tmux, LSP Neovim, etc.)
/bin/bash ~/dotfiles/post-install.sh

# 4. Recargar el shell
exec zsh
```

---

## Stack completo

| Categoría | Herramienta |
|---|---|
| Window manager | AeroSpace |
| Terminal | Ghostty |
| Shell | Zsh + oh-my-zsh + Starship |
| Editor | Neovim (lazy.nvim) |
| Multiplexor | tmux + TPM |
| Status bar | Sketchybar |
| Key remapping | Karabiner-Elements |
| Lanzador | Raycast |
| Historial shell | Atuin |
| Sesiones tmux | sesh |
| Explorador archivos | yazi |

---

## Guía de usuario

### AeroSpace — Gestor de ventanas tiling

AeroSpace organiza las ventanas automáticamente en una cuadrícula, eliminando la necesidad de arrastrar y redimensionar con el ratón.

**Concepto clave:** los workspaces son como espacios de trabajo nombrados. En esta config están asignados a letras con significado: `T` para terminal, `B` para browser, `N` para notas, `F` para Finder, etc.

```
Alt + número/letra    → cambiar de workspace
Alt + Shift + letra   → mover la ventana activa a ese workspace
Alt + h/j/k/l         → mover el foco entre ventanas (estilo vim)
Alt + Shift + h/j/k/l → mover la posición de una ventana
Alt + Tab             → volver al workspace anterior
Alt + Shift + r       → modo resize (luego h/j/k/l para redimensionar)
Alt + ,               → layout accordion (ventanas apiladas con solapamiento)
Alt + /               → layout tiles (ventanas en cuadrícula)
```

Las apps se asignan automáticamente a su workspace al abrirse: Ghostty va a `T`, Brave y Zen Browser van a `B`, Obsidian y Notion van a `N`.

---

### Ghostty — Terminal

Terminal principal. Usa Metal (GPU) para rendering, lo que lo hace notablemente más rápido que iTerm2 en Apple Silicon.

**Configuración relevante:**
- Tema: Rosé Pine
- Fuente: JetBrainsMono NL Nerd Font 20pt (sin ligaduras)
- Opacidad 88% con blur

**Keybinds (prefix: `Ctrl+Space`):**
```
Ctrl+Space > c         → nueva pestaña
Ctrl+Space > n         → nueva ventana
Ctrl+Space > \         → split vertical (panel derecho)
Ctrl+Space > -         → split horizontal (panel inferior)
Ctrl+Space > h/j/k/l   → navegar entre splits
Ctrl+Space > e         → igualar tamaño de splits
Ctrl+Space > 1-9       → ir a pestaña número N
Ctrl+Space > [          → recargar config
```

---

### Zsh + oh-my-zsh + Starship

**Zsh** es el shell. **oh-my-zsh** gestiona los plugins. **Starship** dibuja el prompt.

El prompt muestra: directorio actual (truncado a 4 niveles) + icono del servidor git remoto + rama + estado del repo (staged, modified, ahead/behind).

**Plugins activos:**
- `zsh-syntax-highlighting` — colorea comandos en tiempo real mientras escribes
- `zsh-system-clipboard` — sincroniza el clipboard de Neovim con el del sistema macOS

**Aliases útiles definidos en `.zshrc`:**
```bash
vim       → nvim
lg        → lazygit
ls        → eza (con iconos, colores, info git)
tree      → tree con profundidad 3, ignorando .git
gt/ga/gs  → git / git add . / git status -s
gc        → git commit -m
glog      → git log --oneline --graph --all
tns       → tmux-sessionizer (abre proyecto como sesión)
nlof      → fzf sobre archivos recientes de Neovim
nzo       → búsqueda de archivos con zoxide + fzf + nvim
```

---

### Neovim — Editor

Configuración completa con lazy.nvim como gestor de plugins. El colorscheme activo es **Tokyonight**.

**Estructura de la config:**
```
nvim/.config/nvim/
├── init.lua                    ← punto de entrada
├── lua/
│   ├── current-theme.lua       ← colorscheme activo
│   └── sethy/
│       ├── core/
│       │   ├── options.lua     ← opciones de vim
│       │   └── keymaps.lua     ← keymaps globales
│       ├── lazy.lua            ← bootstrap de lazy.nvim
│       ├── terminalpop.lua     ← terminal flotante (<Space>c/)
│       └── plugins/            ← un archivo por plugin
│           └── lsp/
│               ├── mason.lua   ← instalador de LSP servers
│               └── lspconfig.lua
└── after/ftplugin/             ← settings por tipo de archivo
```

**Keymaps principales (`<leader>` = Space):**
```
<leader>pf    → buscar archivos (fff.nvim)
<leader>ps    → grep en proyecto
<leader>lg    → LazyGit
<leader>ee    → explorador de archivos (mini.files)
<leader>f     → formatear archivo
<leader>u     → undo tree visual
<leader>d     → diagnóstico LSP de la línea
gd            → ir a definición
gR            → ver referencias
K             → documentación del símbolo bajo cursor
<leader>rn    → renombrar símbolo
<leader>vca   → code actions
<Space>c/     → terminal flotante toggle
```

**LSP servers instalados vía Mason:** lua_ls, ts_ls, cssls, tailwindcss, gopls, astro, emmet, marksman.

---

### tmux — Multiplexor de terminal

tmux mantiene sesiones vivas aunque cierres el terminal. Puedes tener un proceso de entrenamiento corriendo en una sesión y el editor en otra, y cambiar entre ellas instantáneamente.

**Prefix por defecto: `Ctrl+b`**

```
Ctrl+b |      → split vertical
Ctrl+b -      → split horizontal
Ctrl+b h/j/k/l → redimensionar panel (también con hjkl + -r)
Ctrl+b m      → maximizar/minimizar panel actual
Ctrl+b r      → recargar tmux.conf

Ctrl+b C-y    → abrir yazi (explorador de archivos) en popup
Ctrl+b C-t    → terminal flotante rápida
Ctrl+b C-g    → lazygit en popup
Ctrl+b K      → selector de sesiones con gum (sesh)
Ctrl+b T      → selector de sesiones con fzf (sesh, más opciones)
Ctrl+b d      → menú de edición de configs (zshrc, tmux.conf, nvim)
```

**Plugins de tmux activos:**
- `catppuccin/tmux` — tema Mocha para la barra de estado
- `tmux-resurrect` — guarda sesiones al apagar y las restaura al encender
- `tmux-continuum` — autoguarda sesiones cada 15 min
- `tmux-sessionx` — selector visual de sesiones (`Ctrl+b o`)
- `vim-tmux-navigator` — `Ctrl+h/j/k/l` navega entre paneles tmux Y splits de Neovim sin distinción

---

### Sketchybar — Barra de estado

Reemplaza la barra de menú de macOS con una completamente personalizada. Muestra: workspaces de AeroSpace, app activa, reloj, WiFi, volumen con slider desplegable, micrófono con selector de dispositivo y batería.

**Interacciones:**
- Click en el icono de volumen → despliega slider + selector de dispositivo de salida
- Click derecho en volumen → mute/unmute
- Click en micrófono → selector de dispositivo de entrada
- Click derecho en micrófono → mute/unmute micro

Los workspaces se iluminan según el workspace activo de AeroSpace en tiempo real.

---

### Karabiner-Elements — Remapeo de teclado

Convierte `CapsLock` en una **Hyper Key** (⌃⌥⇧⌘ simultáneos):
- **Solo CapsLock** (tap sin mantener) → `Escape`
- **CapsLock mantenido** → Hyper Key (activa los atajos siguientes)

**Primera capa (Hyper + tecla directa):**
```
Hyper + t     → abrir Ghostty
Hyper + b     → abrir Brave Browser
Hyper + 1     → abrir DaVinci Resolve
Hyper + 2     → abrir OBS Studio
```

**Sublayers (Hyper + letra de capa + letra de acción):**

| Capa | Tecla | Función |
|---|---|---|
| `o` (open) | `m` | Obsidian |
| `o` | `n` | Notion |
| `o` | `d` | Discord |
| `o` | `f` | Finder |
| `o` | `v` | VS Code |
| `o` | `c` | Zen Browser |
| `w` (window) | `h/j/k/l` | mitad izquierda/abajo/arriba/derecha |
| `w` | `Enter` | maximizar |
| `w` | `y/o` | desktop anterior/siguiente |
| `s` (system) | `u/j` | subir/bajar volumen |
| `s` | `i/k` | subir/bajar brillo |
| `s` | `l` | bloquear pantalla |
| `s` | `p` | play/pause |
| `s` | `d` | Do Not Disturb toggle |
| `s` | `t` | toggle dark/light mode |
| `v` (vim) | `h/j/k/l` | flechas de cursor |
| `v` | `u/i` | page down / page up |
| `c` (media) | `p/n/b` | play-pause / siguiente / anterior |
| `r` (raycast) | `1/2` | conectar dispositivo Bluetooth fav 1/2 |
| `r` | `c` | color picker |
| `r` | `h` | historial del portapapeles |
| `r` | `e` | búsqueda de emojis |

---

### Raycast — Lanzador

Reemplaza Spotlight (`Cmd+Space`). Lanza apps, busca archivos, ejecuta scripts y extensiones.

Los atajos de Karabiner abren extensiones específicas de Raycast directamente sin necesidad de abrir la UI principal. Las extensiones referenciadas en la config que necesitas instalar manualmente desde la Raycast Store:

- **Toothpick** — conexión rápida a dispositivos Bluetooth favoritos (`Hyper+r+1`, `Hyper+r+2`)
- **Do Not Disturb** (yakitrak) — toggle de no molestar (`Hyper+s+d`)
- **Color Picker** (thomas) — captura el color de cualquier píxel de la pantalla (`Hyper+r+c`)
- **Folder Search** (GastroGeek) — búsqueda rápida de carpetas (`Hyper+p+f`)
- **File Manager** (erics118) — gestión de archivos (`Hyper+m+f`)

---

### Atuin — Historial de shell

Reemplaza el historial de zsh (`Ctrl+R`) con una base de datos SQLite que permite buscar por comando, directorio, fecha y código de salida.

```
Ctrl+R        → abrir búsqueda (modo vim-insert por defecto)
Tab           → volver al shell con el comando seleccionado para editar
Enter         → ejecutar directamente
```

Config activa: `keymap_mode = "vim-insert"` (puedes usar `/` para buscar dentro del TUI), `enter_accept = true` (Enter ejecuta sin confirmación adicional), `inline_height = 20` (ocupa 20 líneas en vez de pantalla completa).

---

### sesh — Gestor de sesiones tmux

sesh combina tmux + zoxide para crear y cambiar entre sesiones de proyectos en milisegundos. Entiende git repos y worktrees, nombrando las sesiones de forma inteligente.

```bash
# Desde la terminal:
sesh list              → lista sesiones activas + directorios frecuentes
sesh connect <dir>     → conecta o crea sesión para ese directorio

# Desde tmux:
Ctrl+b K               → popup con gum (interfaz limpia)
Ctrl+b T               → popup con fzf (más opciones: filtrar por tipo, matar sesión)
```

La integración con zoxide significa que los directorios que visitas frecuentemente (proyectos de Python, repos de IA) aparecen automáticamente en el selector sin configuración manual.

---

### yazi — Explorador de archivos en terminal

Explorador de archivos con layout de 3 columnas (padre / actual / preview), vim-keybindings y preview de imágenes directamente en el terminal (Ghostty lo soporta nativamente).

```
h/j/k/l o flechas  → navegar
Enter              → abrir archivo/entrar en directorio
-                  → subir al directorio padre
y                  → copiar archivo
d                  → mover a papelera
r                  → renombrar
/                  → buscar
Tab                → selección múltiple
```

Se abre como popup en tmux con `Ctrl+b → Ctrl+y`.

---

### fzf + fd + ripgrep — Búsqueda

**fzf** es un filtro fuzzy universal. Por sí solo no hace nada; potencia otros comandos:
```bash
Ctrl+T    → buscar archivos y pegarlos en el comando actual
Ctrl+R    → historial (sobreescrito por atuin, pero disponible)
Alt+C     → buscar directorio y cd a él
**<Tab>   → completar rutas y procesos con fuzzy find
```

**fd** reemplaza `find` con mejor sintaxis:
```bash
fd nombre              → buscar archivos por nombre
fd -e py               → buscar por extensión
fd -t d nombre         → buscar solo directorios
```

**ripgrep** (`rg`) busca texto dentro de archivos, respeta `.gitignore`, es mucho más rápido que `grep -r`:
```bash
rg "def train"         → buscar en todos los archivos del proyecto
rg -t py "import"      → solo en archivos Python
```

Los tres están integrados en Neovim: `<leader>pf` usa fd, `<leader>ps` usa ripgrep.

---

### zoxide — cd inteligente

Aprende qué directorios visitas y te permite saltar a ellos con fragmentos del nombre:
```bash
z dotfiles     → cd ~/dotfiles (aunque estés en cualquier sitio)
z proj api     → cd al directorio que coincida con "proj" y "api"
zi             → fuzzy finder interactivo de directorios frecuentes
```

---

### lazygit — Git visual en terminal

TUI completo para git. Se abre con `lg` o desde tmux con `Ctrl+b → Ctrl+g`.

```
1/2/3/4/5     → navegar entre paneles (status, branches, commits, etc.)
Space         → stage/unstage archivo o hunk
c             → commit
p             → push
P             → pull
b             → branches
m             → merge
r             → rebase
?             → ayuda contextual
```

---

### BetterDisplay — Gestión de pantallas externas

Solo relevante si conectas un monitor externo. Desbloquea resoluciones HiDPI en monitores no Apple, permite escalar el brillo de monitores que no soportan control de brillo nativo, y gestiona la configuración DDC.

Si trabajas solo con la pantalla del MacBook, no necesitas abrirlo.

---

### Linearmouse — Control de ratón/trackpad

Elimina la aceleración del puntero en ratones externos y permite ajustar la velocidad independientemente del trackpad. Si usas exclusivamente el trackpad del MacBook, puedes ignorarlo.

---

### Keycastr — Visualización de teclas

Muestra en pantalla las teclas que pulsas en tiempo real. Útil para grabaciones de código, demos técnicas o presentaciones donde el público necesita ver los atajos que usas.

---

## Adaptaciones respecto al repo original

| Archivo | Cambio |
|---|---|
| `zsh/.zprofile` | Eliminadas rutas `/Users/personal` → `$HOME`. Guards para Deno, bun, Console Ninja. |
| `zsh/.zshrc` | Eliminadas rutas hardcodeadas. Guards para `but` y `wtp`. |
| `sketchybar/plugins/wifi.sh` | `airport` (eliminado en macOS Sequoia/Tahoe) → `networksetup`. |
| `install.sh` | Eliminado tap `homebrew/cask-fonts` deprecado. Dependencias completas. TPM en ruta correcta. Sin mpd/wezterm/alacritty/font-sf-pro (ya en macOS Tahoe). |
| `nvim/lazy.lua` | `vim.loop` → `vim.uv` (Neovim ≥ 0.10). |
| `nvim/snacks.lua` | Eliminada ruta hardcodeada de imagen del dashboard. |

## Hardware

MacBook Pro 14" M5 Pro (2026) · Space Black · 64 GB · 1 TB SSD · macOS Tahoe 26
