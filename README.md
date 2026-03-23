# dotfiles — MacBook Pro 14" M5 Pro

Dotfiles para macOS adaptados para **MacBook Pro 14" M5 Pro** (Apple Silicon ARM64), macOS Tahoe 26.

---

## Instalación rápida

```bash
git clone https://github.com/dalonsogomez/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles && chmod +x install.sh && /bin/bash install.sh
/bin/bash ~/dotfiles/post-install.sh
exec zsh
```

---

## Stack completo

| Categoría | Herramienta |
|---|---|
| Window manager tiling | AeroSpace |
| Terminal | Ghostty |
| Shell | Zsh + oh-my-zsh + Starship |
| Editor | Neovim (lazy.nvim) |
| Multiplexor de terminal | tmux + TPM |
| Status bar | Sketchybar |
| Remapeo de teclado | Karabiner-Elements |
| Lanzador | Raycast |
| Historial de shell | Atuin |
| Gestor de sesiones tmux | sesh |
| Explorador de archivos TUI | yazi |
| Búsqueda fuzzy | fzf |
| Find moderno | fd |
| Grep moderno | ripgrep |
| cd inteligente | zoxide |
| Git TUI | lazygit |
| Pantallas externas | BetterDisplay |
| Control de ratón | Linearmouse |
| Visualización de teclas | Keycastr |

---

## Guía de usuario

### 1. AeroSpace — Gestor de ventanas tiling

AeroSpace organiza las ventanas automáticamente en una cuadrícula sin superposición. No hay animaciones ni arrastres: las ventanas se colocan al abrir la app y se redistribuyen al cerrar otra. Está inspirado en i3 (Linux) y opera completamente sin deshabilitar SIP.

**Concepto de workspaces:** los workspaces son espacios de trabajo nombrados. Las apps se asignan automáticamente a su workspace al detectarse:

| Workspace | App asignada automáticamente |
|---|---|
| `T` | Ghostty |
| `B` | Brave Browser, Zen Browser |
| `N` | Notion, Obsidian |
| `F` | Finder (modo floating) |
| `1–5`, `8–9`, `M` | Libres |

**Keybinds — modo main:**

| Shortcut | Acción |
|---|---|
| `Alt + 1-5 / 8-9` | Cambiar al workspace numérico |
| `Alt + b / f / m / n / t` | Cambiar al workspace nombrado |
| `Alt + Shift + 1-5 / 8-9` | Mover ventana activa al workspace numérico |
| `Alt + Shift + b/f/m/n/t` | Mover ventana activa al workspace nombrado |
| `Alt + h / j / k / l` | Mover el foco a la ventana izquierda/abajo/arriba/derecha |
| `Alt + Shift + h/j/k/l` | Mover la ventana en esa dirección |
| `Alt + Tab` | Alternar entre los dos últimos workspaces |
| `Alt + Shift + Tab` | Mover el workspace al siguiente monitor |
| `Alt + Shift + Enter` | **Toggle Floating / Tiling** (Maximizar/Centrar instantáneo) |
| `Alt + /` | Layout tiles (cuadrícula sin superposición) |
| `Alt + ,` | Layout accordion (Foco central: expande ventana actual, encoge laterales) |
| `Alt + Shift + ;` | Entrar en modo service |
| `Alt + Shift + r` | Entrar en modo resize |

**Comportamiento del ratón:**
- `on-focused-monitor-changed`: El ratón se centra al cambiar de monitor.
- `on-focus-changed`: **Mouse follows focus**. Al cambiar de ventana con el teclado (`Alt + h/j/k/l`), el cursor salta automáticamente al centro de la nueva ventana. Ideal para no "perder" el ratón en pantallas grandes como el BenQ M27UP.

**Modo resize** (`Alt + Shift + r`, luego):

| Tecla | Acción |
|---|---|
| `h / j / k / l` | Redimensionar ±50px en esa dirección |
| `b` | Igualar tamaño de todas las ventanas del workspace |
| `Enter` o `Esc` | Volver al modo main |

**Modo service** (`Alt + Shift + ;`, luego):

| Tecla | Acción |
|---|---|
| `Esc` | Recargar config y volver al modo main |
| `r` | Resetear layout del workspace (flatten tree) |
| `f` | Toggle floating / tiling de la ventana actual |
| `Backspace` | Cerrar todas las ventanas menos la actual |
| `Alt + Shift + h/j/k/l` | Unir ventana con la adyacente (join-with) |

**Gaps:** 15px entre ventanas, 30px en bordes exteriores. Gap superior adaptativo por monitor (10px en Retina integrado, 20px en M27UP externo).

---

### 2. Ghostty — Terminal

Ghostty usa Metal (GPU nativa ARM64) para el rendering, lo que lo hace significativamente más rápido que iTerm2 en Apple Silicon. Soporta splits y pestañas nativos sin necesidad de tmux para gestión básica.

**Config activa:**
- Tema: Rosé Pine
- Fuente: JetBrainsMono NL Nerd Font, 20pt, sin ligaduras (`-liga`, `-calt`, `-dlig`)
- Opacidad de fondo: 88% con blur radius 25
- Cursor: bloque, sin parpadeo
- `macos-option-as-alt = false` — Se mantiene en `false` para evitar conflictos con los atajos de AeroSpace y permitir el uso de `Option + n` para la `ñ`.
- `copy-on-select = clipboard` — la selección con ratón copia automáticamente al clipboard del sistema
- `mouse-hide-while-typing = true` — el cursor del ratón desaparece al escribir

**Keybinds (sistema de secuencias con prefijo `Ctrl+Space`):**

| Shortcut | Acción |
|---|---|
| `Ctrl+Space > c` | Nueva pestaña |
| `Ctrl+Space > n` | Nueva ventana |
| `Ctrl+Space > x` | Cerrar split/superficie actual |
| `Ctrl+Space > \` | Nuevo split a la derecha (vertical) |
| `Ctrl+Space > -` | Nuevo split abajo (horizontal) |
| `Ctrl+Space > e` | Igualar tamaño de todos los splits |
| `Ctrl+Space > h/j/k/l` | Navegar entre splits |
| `Ctrl+Space > 1-9` | Ir a la pestaña número N |
| `Ctrl+Space > [` | Recargar config de Ghostty |
| `Cmd + Shift + ,` | Recargar config (shortcut macOS por defecto) |
| `Ctrl + [` | Enviar Escape al terminal (equivalente a Esc) |
| `Cmd + I` | Toggle del inspector de Ghostty |

**Nota sobre el prefijo:** `Ctrl+Space` requiere que no haya un segundo layout de teclado activo en macOS, ya que el sistema lo usaría para cambiar de layout. Con un único layout US ABC activo no hay conflicto.

---

### 3. Zsh + oh-my-zsh + Starship

**Zsh** es el shell. **oh-my-zsh** gestiona plugins y el framework del shell. **Starship** renderiza el prompt con información contextual de git, lenguaje activo y directorio.

**Prompt Starship:** muestra directorio actual truncado a 4 niveles + icono del hosting de git (GitHub, GitLab…) + rama actual + estado del repo (staged, modified, ahead/behind commits). El formato es limpio y solo aparece información relevante según el contexto del directorio.

**Plugins oh-my-zsh activos:**
- `git` — aliases de git abreviados (`gst`, `gco`, `gcmsg`, etc.)
- `zsh-syntax-highlighting` — colorea comandos mientras escribes (verde = válido, rojo = no encontrado)
- `zsh-system-clipboard` — sincroniza el clipboard de Neovim con el clipboard del sistema macOS

**Aliases definidos en `.zshrc`:**

| Alias | Comando real |
|---|---|
| `vim` | `nvim` |
| `lg` | `lazygit` |
| `ls` | `eza --icons --color=always --group-directories-first` |
| `ll` | `eza -la --icons --color=always` |
| `tree` | `eza --tree --level=3 --ignore-glob=".git"` |
| `gt` | `git` |
| `ga` | `git add .` |
| `gs` | `git status -s` |
| `gc` | `git commit -m` |
| `glog` | `git log --oneline --graph --all --decorate` |
| `tns` | `tmux-sessionizer` (crea/conecta sesión de proyecto) |
| `nlof` | `fzf` sobre el historial de archivos recientes de Neovim |
| `nzo` | Búsqueda de archivos con zoxide + fzf, abre en nvim |

**PATH y entorno configurados en `.zprofile`:**
- Homebrew ARM64 (`/opt/homebrew/bin`) inicializado correctamente
- Deno (`$HOME/.deno/bin`) con guard de existencia
- bun (`$HOME/.bun/bin`) con guard de existencia
- `EDITOR=nvim`, `VISUAL=nvim`

---

### 4. Neovim — Editor

Configuración modular con **lazy.nvim** como gestor de plugins. Colorscheme activo: **Tokyonight**. Diseñado para desarrollo en Python, TypeScript, Go, Lua, CSS/HTML y Markdown.

**Estructura de la config:**

```
nvim/.config/nvim/
├── init.lua                      ← punto de entrada
└── lua/sethy/
    ├── core/
    │   ├── options.lua           ← opciones de vim (número de línea, tabs, etc.)
    │   └── keymaps.lua           ← keymaps globales
    ├── lazy.lua                  ← bootstrap de lazy.nvim
    ├── terminalpop.lua           ← terminal flotante toggle
    ├── current-theme.lua         ← colorscheme activo
    └── plugins/                  ← un archivo .lua por plugin
        └── lsp/
            ├── mason.lua         ← instalador automático de LSP servers
            └── lspconfig.lua     ← configuración de cada LSP
```

**Keymaps principales (`<leader>` = `Space`):**

| Keymap | Acción |
|---|---|
| `<leader>pf` | Buscar archivos en el proyecto (fuzzy, usa fd) |
| `<leader>ps` | Buscar texto en el proyecto (grep, usa ripgrep) |
| `<leader>ee` | Explorador de archivos (mini.files) |
| `<leader>f` | Formatear el archivo actual |
| `<leader>u` | Undo tree visual (ver historial de cambios) |
| `<leader>lg` | Abrir LazyGit dentro de Neovim |
| `<leader>d` | Diagnóstico LSP de la línea actual |
| `<leader>D` | Diagnóstico LSP de todo el buffer |
| `<Space>c/` | Toggle terminal flotante |
| `gd` | Ir a definición |
| `gD` | Ir a declaración |
| `gR` | Ver todas las referencias del símbolo |
| `K` | Documentación hover del símbolo bajo el cursor |
| `<leader>rn` | Renombrar símbolo (LSP rename) |
| `<leader>vca` | Code actions del LSP |
| `<leader>vws` | Buscar símbolo en el workspace |
| `[d` / `]d` | Navegar al diagnóstico anterior/siguiente |

**LSP servers instalados vía Mason:**
`lua_ls`, `ts_ls`, `cssls`, `html-lsp`, `tailwindcss`, `gopls`, `astro`, `angular`, `emmet-language-server`, `emmet-ls`, `deno`, `marksman`, `pylint`, `prettier`, `stylua`, `clangd`

**Plugins destacados:**
- `telescope.nvim` — búsqueda de archivos y texto (fzf-like dentro de nvim)
- `nvim-treesitter` — syntax highlighting y text objects semánticos
- `nvim-cmp` — autocompletado con fuentes de LSP, snippets, buffer y path
- `nvim-autopairs` — cierre automático de paréntesis, llaves y comillas
- `gitsigns.nvim` — indicadores de diff de git en el gutter
- `lualine.nvim` — barra de estado inferior
- `snacks.nvim` — collection de utilidades (dashboard, notificaciones, etc.)
- `vim-tmux-navigator` — navegación unificada entre splits de nvim y paneles de tmux

---

### 5. tmux — Multiplexor de terminal

tmux mantiene sesiones persistentes independientes del terminal. Puedes cerrar Ghostty, volver a abrirlo y `tmux attach` para retomar exactamente donde lo dejaste. Con `tmux-resurrect` y `tmux-continuum`, las sesiones sobreviven incluso a un reinicio del sistema.

**Prefix: `Ctrl+b`**

**Splits y ventanas:**

| Shortcut | Acción |
|---|---|
| `Ctrl+b \|` | Nuevo split vertical (panel a la derecha) |
| `Ctrl+b -` | Nuevo split horizontal (panel abajo) |
| `Ctrl+b x` | Cerrar panel actual (sin confirmación) |
| `Ctrl+b m` | Maximizar/restaurar panel actual (zoom) |
| `Ctrl+b h/j/k/l` | Redimensionar el panel en esa dirección (repetible con `-r`) |
| `Ctrl+b r` | Recargar `tmux.conf` |
| `Ctrl+b v` | Entrar en modo copy (vim) |

**Sesiones con sesh:**

| Shortcut | Acción |
|---|---|
| `Ctrl+b K` | Popup con selector de sesiones usando gum (interfaz limpia) |
| `Ctrl+b T` | Popup con selector de sesiones usando fzf (más opciones) |
| `Ctrl+b o` | tmux-sessionx: selector visual avanzado de sesiones |
| `Ctrl+b n` | Crear nueva sesión con nombre personalizado |
| `Ctrl+b f` | tmux-sessionizer: crea sesión para un proyecto con fzf |

**En el selector fzf de sesh (`Ctrl+b T`):**

| Keybind fzf | Acción |
|---|---|
| `Ctrl+a` | Mostrar todas las sesiones y directorios |
| `Ctrl+t` | Mostrar solo sesiones tmux activas |
| `Ctrl+g` | Mostrar solo repos git |
| `Ctrl+x` | Mostrar directorios frecuentes de zoxide |
| `Ctrl+f` | Buscar directorios con fd |
| `Ctrl+d` | Eliminar sesión seleccionada |

**Popups de herramientas:**

| Shortcut | Acción |
|---|---|
| `Ctrl+b Ctrl+y` | Abrir yazi (explorador de archivos) en popup 90%×90% |
| `Ctrl+b Ctrl+t` | Terminal flotante rápida en popup 80%×80% |
| `Ctrl+b Ctrl+g` | Lazygit en popup 90%×90% (en el directorio del pane actual) |
| `Ctrl+b d` | Menú de edición de configs (zshrc, zprofile, tmux.conf, nvim) |

**Copy mode vim (`Ctrl+b v` para entrar):**

| Keybind | Acción |
|---|---|
| `v` | Iniciar selección |
| `y` | Copiar selección al clipboard |
| `q` o `Esc` | Salir del copy mode |

**Plugins activos:**

| Plugin | Función |
|---|---|
| `catppuccin/tmux` | Tema visual Mocha para toda la barra de estado |
| `tmux-resurrect` | Guarda y restaura sesiones, ventanas y paneles manualmente (`Ctrl+b Ctrl+s` / `Ctrl+b Ctrl+r`) |
| `tmux-continuum` | Autoguarda sesiones cada 15 min y las restaura al arrancar tmux |
| `tmux-sessionx` | Selector visual avanzado de sesiones con preview (`Ctrl+b o`) |
| `vim-tmux-navigator` | `Ctrl+h/j/k/l` navega entre paneles tmux Y splits de Neovim sin distinción |
| `tmux-online-status` | Indicador de conectividad en la barra de estado |
| `tmux-battery` | Estado de batería en la barra de estado |

**Barra de estado:** muestra sesión activa (rojo si prefix activo, verde si no), directorio del pane actual (truncado a 32 chars), indicador de zoom, conectividad de red. Posición: inferior, centrada.

---

### 6. Sketchybar — Barra de estado personalizada

Reemplaza la barra de menú de macOS con una barra completamente programable. Cada widget es un script shell. Se integra con AeroSpace para mostrar el workspace activo en tiempo real.

**Widgets de izquierda a derecha:**
- **Workspaces AeroSpace** — los workspaces configurados se iluminan al activarse. Click en uno cambia directamente a ese workspace.
- **App activa** — nombre de la aplicación con foco.
- **Volumen** — icono con nivel actual. Click izquierdo despliega slider + selector de dispositivo de salida de audio. Click derecho hace mute/unmute.
- **Micrófono** — icono con estado. Click izquierdo abre selector de dispositivo de entrada. Click derecho hace mute/unmute del micro.
- **Batería** — porcentaje + icono de estado (cargando, en uso, completo).
- **Reloj** — fecha y hora en formato configurable.
- **WiFi** — red actual o estado desconectado. Usa `networksetup` para compatibilidad con macOS Sequoia/Tahoe (el comando `airport` fue eliminado en estas versiones).

**Servicio:** Sketchybar corre como servicio de Homebrew. Para gestionarlo:
```bash
brew services start sketchybar   # arrancar
brew services stop sketchybar    # detener
brew services restart sketchybar # reiniciar (tras cambios en config)
```

**Config:** `~/.config/sketchybar/sketchybarrc` (archivo principal) + `items/` (widgets) + `plugins/` (scripts de actualización) + `colors.sh` + `icons.sh`.

---

### 7. Karabiner-Elements — Remapeo de teclado

Convierte `CapsLock` en una **Hyper Key** (⌃⌥⇧⌘ simultáneos), la combinación de modificadores menos probable de entrar en conflicto con cualquier app. El hardware detectado es ANSI (`keyboard_type_v2: "ansi"`) — correcto para el teclado US del MacBook Pro M5 Pro.

**CapsLock:**
- **Tap solo** → `Escape`
- **Mantener** → activa Hyper Key (⌃⌥⇧⌘)
- **Bloqueo de Mayúsculas:** Como CapsLock es ahora Hyper, para activar el bloqueo de mayúsculas real pulsa **ambos Shift simultáneamente**.

**Primera capa — Hyper + tecla directa:**

| Shortcut | Acción |
|---|---|
| `Hyper + t` | Abrir Ghostty |
| `Hyper + b` | Abrir Brave Browser |
| `Hyper + 1` | Abrir DaVinci Resolve |
| `Hyper + 2` | Abrir OBS Studio |

**Sublayers** (Hyper + letra de capa activada, luego letra de acción — se mantiene Hyper pulsado durante toda la secuencia):

**Capa `o` — Open (abrir apps):**

| `Hyper + o + ...` | Acción |
|---|---|
| `m` | Obsidian |
| `n` | Notion |
| `d` | Discord |
| `i` | Messages |
| `f` | Finder |
| `p` | Music |
| `v` | **Visual Studio Code - Insiders** |
| `c` | Zen Browser |

**Capa `w` — Window (gestión de ventanas vía Raycast):**

| `Hyper + w + ...` | Acción |
|---|---|
| `h` | Ventana a la mitad izquierda |
| `l` | Ventana a la mitad derecha |
| `k` | Ventana a la mitad superior |
| `j` | Ventana a la mitad inferior |
| `Enter` | Maximizar ventana |
| `y` | Desktop/espacio anterior |
| `o` | Desktop/espacio siguiente |
| `d` | Mover ventana al siguiente monitor |
| `n` | Siguiente ventana de la misma app (`Cmd+\``) |
| `u` | Pestaña anterior (`Ctrl+Shift+Tab`) |
| `i` | Pestaña siguiente (`Ctrl+Tab`) |
| `b` | Navegar atrás en el browser (`Cmd+[`) |
| `f` | Navegar adelante en el browser (`Cmd+]`) |
| `m` | Siguiente ventana de la app (`Ctrl+,`) |
| `;` | Ocultar ventana (`Cmd+H`) |

**Capa `s` — System (controles del sistema):**

| `Hyper + s + ...` | Acción |
|---|---|
| `u` | Subir volumen |
| `j` | Bajar volumen |
| `i` | Subir brillo de pantalla |
| `k` | Bajar brillo de pantalla |
| `l` | Bloquear pantalla (`Ctrl+Cmd+Q`) |
| `p` | Play/Pause |
| `;` | Avanzar pista (fastforward) |
| `d` | Toggle Do Not Disturb (Raycast) |
| `t` | Toggle dark/light mode (Raycast) |
| `c` | Abrir cámara (Raycast) |

**Capa `v` — Vim (navegación de cursor en cualquier app):**

| `Hyper + v + ...` | Acción |
|---|---|
| `h` | Flecha izquierda |
| `j` | Flecha abajo |
| `k` | Flecha arriba |
| `l` | Flecha derecha |
| `u` | Page Down |
| `i` | Page Up |
| `s` | `Ctrl+J` (scroll o atajos compatibles) |
| `d` | `Shift+Cmd+D` |

**Capa `c` — Control de medios:**

| `Hyper + c + ...` | Acción |
|---|---|
| `p` | Play/Pause |
| `n` | Siguiente pista |
| `b` | Pista anterior |

**Capa `r` — Raycast (extensiones directas):**

| `Hyper + r + ...` | Acción |
|---|---|
| `1` | Conectar dispositivo Bluetooth favorito 1 (Toothpick) |
| `2` | Conectar dispositivo Bluetooth favorito 2 (Toothpick) |
| `c` | Color picker |
| `n` | Raycast Notes |
| `e` | Búsqueda de emojis |
| `p` | Confetti (celebración) |
| `h` | Historial del portapapeles |

**Capa `p` — Búsqueda de archivos:**

| `Hyper + p + ...` | Acción |
|---|---|
| `s` | Buscar archivos (Raycast file-search) |
| `f` | Buscar carpetas (Folder Search extension) |

**Capa `m` — File Manager:**

| `Hyper + m + ...` | Acción |
|---|---|
| `f` | Abrir File Manager (erics118 extension) |

---

### 8. Raycast — Lanzador

Reemplaza Spotlight (`Cmd+Space`). Lanza apps, busca archivos, ejecuta scripts, gestiona el portapapeles y corre extensiones de la comunidad.

**Uso básico:**
- `Cmd+Space` → abrir Raycast
- Escribir el nombre de una app, archivo o comando → Enter para ejecutar
- `Cmd+K` dentro de Raycast → ver acciones disponibles del resultado seleccionado

**Extensiones referenciadas en la config de Karabiner (instalar desde la Raycast Store):**

| Extensión | Autor | Función | Shortcut Karabiner |
|---|---|---|---|
| Toothpick | VladCuciureanu | Conectar dispositivos Bluetooth favoritos | `Hyper+r+1`, `Hyper+r+2` |
| Do Not Disturb | yakitrak | Toggle de modo no molestar | `Hyper+s+d` |
| Color Picker | thomas | Captura el color de cualquier píxel | `Hyper+r+c` |
| Folder Search | GastroGeek | Búsqueda rápida de carpetas | `Hyper+p+f` |
| File Manager | erics118 | Gestión de archivos | `Hyper+m+f` |
| Window Management | raycast (built-in) | Mitades y maximizar ventanas | `Hyper+w+*` |
| System | raycast (built-in) | Dark mode, cámara, etc. | `Hyper+s+t`, `Hyper+s+c` |
| Clipboard History | raycast (built-in) | Historial del portapapeles | `Hyper+r+h` |
| Emoji Symbols | raycast (built-in) | Búsqueda de emojis | `Hyper+r+e` |

---

### 9. Atuin — Historial de shell

Reemplaza el historial estándar de zsh con una base de datos SQLite que registra cada comando junto con su directorio, código de salida, duración y fecha. Permite filtrar por cualquiera de esos campos.

**Uso:**

| Shortcut | Acción |
|---|---|
| `Ctrl+R` | Abrir el buscador de historial de Atuin |
| `Tab` | Seleccionar el comando para editarlo antes de ejecutar |
| `Enter` | Ejecutar el comando seleccionado directamente |
| `Esc` | Cerrar sin ejecutar |

**Config activa (`~/.config/atuin/config.toml`):**
- `keymap_mode = "vim-insert"` — el buscador arranca en modo insert; pulsa `Esc` para entrar en modo normal de vim y usar `/` para buscar dentro del historial
- `enter_accept = true` — Enter ejecuta sin un paso de confirmación adicional
- `inline_height = 20` — el buscador ocupa 20 líneas en lugar de pantalla completa
- El historial se almacena localmente en SQLite; no hay sincronización remota habilitada por defecto

---

### 10. sesh — Gestor de sesiones tmux

sesh combina tmux con zoxide para crear y cambiar entre sesiones de proyectos en milisegundos. Entiende repositorios git y worktrees, y nombra las sesiones de forma limpia (último componente del path).

**Desde la terminal:**
```bash
sesh list                  # lista sesiones activas + directorios frecuentes de zoxide
sesh connect ~/proyectos/x # conecta a la sesión de ese directorio (o la crea)
sesh preview <nombre>      # vista previa de la sesión
```

**Desde tmux:**
- `Ctrl+b K` — selector con gum (simple, visual, sin fzf)
- `Ctrl+b T` — selector con fzf (completo, con filtros por tipo, preview en tiempo real, posibilidad de matar sesiones)
- `Ctrl+b o` — tmux-sessionx (selector visual con interfaz propia)

Los directorios que visitas frecuentemente aparecen en el selector automáticamente gracias a la integración con zoxide — sin configuración manual de proyectos.

---

### 11. yazi — Explorador de archivos TUI

Explorador de archivos con layout de 3 columnas (directorio padre / directorio actual / preview del archivo seleccionado). Soporta preview de imágenes directamente en Ghostty (protocol Kitty). Vim-keybindings.

**Navegación:**

| Tecla | Acción |
|---|---|
| `h` o `←` | Subir al directorio padre |
| `j` o `↓` | Bajar en la lista |
| `k` o `↑` | Subir en la lista |
| `l` o `→` / `Enter` | Entrar en directorio / abrir archivo |
| `/` | Buscar en el directorio actual |
| `f` | Filtrar archivos |
| `Tab` | Selección múltiple (toggle) |

**Operaciones de archivos:**

| Tecla | Acción |
|---|---|
| `y` | Copiar archivo(s) seleccionado(s) |
| `x` | Cortar archivo(s) |
| `p` | Pegar |
| `d` | Mover a papelera |
| `D` | Eliminar permanentemente |
| `r` | Renombrar |
| `a` | Crear archivo o directorio (terminar en `/` para directorio) |
| `Space` | Seleccionar/deseleccionar sin mover el cursor |

**Acceso:** `Ctrl+b Ctrl+y` desde tmux (popup flotante), o directamente `yazi` desde la terminal.

---

### 12. fzf + fd + ripgrep — Búsqueda

Estas tres herramientas trabajan juntas como infraestructura de búsqueda del sistema.

**fzf** — filtro fuzzy interactivo universal:

| Shortcut | Acción |
|---|---|
| `Ctrl+T` | Buscar archivos y pegar la ruta en el comando actual |
| `Ctrl+R` | Historial de comandos (disponible, pero Atuin toma precedencia) |
| `Alt+C` | Buscar directorio y hacer cd a él |
| `**` + `Tab` | Completar rutas, procesos o hosts con fuzzy find |

Dentro del buscador fzf: `Ctrl+J/K` o flechas para navegar, `Tab` para selección múltiple, `Enter` para confirmar.

**fd** — reemplaza `find` con sintaxis más limpia y rápida:
```bash
fd nombre                  # buscar archivo por nombre
fd -e py                   # buscar por extensión
fd -t d nombre             # buscar solo directorios
fd -H nombre               # incluir archivos ocultos
fd --exclude node_modules  # excluir directorio
```

**ripgrep (`rg`)** — grep moderno, respeta `.gitignore`, mucho más rápido:
```bash
rg "texto"                 # buscar en todos los archivos del proyecto
rg -t py "import torch"    # solo en archivos Python
rg -l "TODO"               # solo mostrar nombres de archivos
rg --no-ignore "texto"     # ignorar .gitignore
```

Ambos están integrados en Neovim: `<leader>pf` usa fd, `<leader>ps` usa ripgrep.

---

### 13. zoxide — cd inteligente

Aprende qué directorios visitas con más frecuencia y permite saltar a ellos con fragmentos del nombre, sin importar desde dónde estés.

```bash
z dotfiles              # cd ~/dotfiles
z proj api              # cd al directorio que coincida con "proj" y "api"
zi                      # abre fzf interactivo con los directorios más frecuentes
z ..                    # equivalente a cd ..
```

La base de datos de zoxide alimenta también el selector de sesiones de sesh (`Ctrl+b T → Ctrl+x`).

---

### 14. lazygit — Git TUI

Interfaz visual completa para git dentro del terminal. Se abre con `lg` desde cualquier repo, o desde tmux con `Ctrl+b Ctrl+g` (popup en el directorio actual).

**Navegación entre paneles:**

| Tecla | Panel |
|---|---|
| `1` | Status / archivos modificados |
| `2` | Branches |
| `3` | Historial de commits |
| `4` | Stash |
| `5` | Submodules |

**Operaciones principales:**

| Tecla | Acción |
|---|---|
| `Space` | Stage / unstage archivo o hunk |
| `a` | Stage / unstage todos los archivos |
| `c` | Commit |
| `C` | Commit con editor externo (nvim) |
| `p` | Push |
| `P` | Pull |
| `f` | Fetch |
| `b` | Abrir panel de branches |
| `n` | Crear nueva branch |
| `m` | Merge de la branch seleccionada |
| `r` | Rebase interactivo |
| `d` | Eliminar branch o archivo |
| `e` | Abrir archivo en el editor |
| `Enter` | Ver diff del archivo / expandir commit |
| `[` / `]` | Navegar entre paneles |
| `?` | Ayuda contextual del panel actual |
| `q` | Salir |

---

### 15. BetterDisplay — Gestión de pantallas externas

Relevante solo al conectar monitores externos. Desbloquea resoluciones HiDPI (Retina-like) en monitores no-Apple, permite controlar el brillo de monitores sin DDC/CI nativo, y gestiona la configuración de múltiples displays.

**Funcionalidades principales:**
- Resoluciones HiDPI personalizadas para cualquier monitor
- Control de brillo por software en monitores sin soporte DDC
- Gestión del monitor integrado (deshabilitar, rotar, modo espejo)
- Perfiles de configuración por set de monitores conectados

Si trabajas exclusivamente con la pantalla del MacBook Pro, no necesitas abrirlo.

---

### 16. Linearmouse — Control de ratón/trackpad

Permite configurar independientemente el comportamiento del ratón externo y del trackpad. El caso de uso más común es eliminar la aceleración del puntero en ratones gaming o de precisión.

**Funcionalidades principales:**
- Desactivar la aceleración del puntero por dispositivo
- Ajustar velocidad de desplazamiento (scroll) independientemente del sistema
- Invertir dirección de scroll por dispositivo
- Configuración de botones laterales del ratón

Si usas exclusivamente el trackpad del MacBook, puedes ignorarlo.

---

### 17. Keycastr — Visualización de teclas en pantalla

Muestra en pantalla las teclas que pulsas en tiempo real. Útil para grabaciones de código, demos técnicas o cualquier presentación donde el público necesita ver los atajos que usas.

**Uso:** abre Keycastr desde el icono de la barra de menú. Elige el estilo de visualización (posición en pantalla, tamaño, duración). Pulsa cualquier tecla y aparece en el overlay.

---

## Adaptaciones respecto al repo original (Sin-cy/dotfiles)

| Archivo | Cambio |
|---|---|
| `zsh/.zprofile` | Rutas `/Users/personal` → `$HOME`. Guards para Deno, bun, Console Ninja. |
| `zsh/.zshrc` | Rutas hardcodeadas eliminadas. Guards para `but` y `wtp`. |
| `sketchybar/plugins/wifi.sh` | `airport` CLI (eliminado en Sequoia/Tahoe) → `networksetup -getairportnetwork en0`. |
| `install.sh` | Guard de Homebrew. Casks instalados individualmente con fallback. Guard de oh-my-zsh. Backup pre-stow. TPM en ruta correcta. Eliminados: mpd, mpc, rmpc, wezterm, alacritty, font-hack-nerd-font, font-sf-pro. |
| `nvim/lazy.lua` | `vim.loop.fs_stat` → `vim.uv.fs_stat` (Neovim ≥ 0.10). |
| `nvim/snacks.lua` | Eliminada ruta hardcodeada de imagen del dashboard. |
| `tmux/tmux.conf` | `#{pane-current-path}` → `#{pane_current_path}`. Comillas internas del display-menu corregidas. |

---

## Hardware de referencia

MacBook Pro 14" M5 Pro (2026) · Space Black · 64 GB RAM unificada · 1 TB SSD · macOS Tahoe 26 · Teclado US English ABC (ANSI)
