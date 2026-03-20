eval "$(/opt/homebrew/bin/brew shellenv)"

export LANG=en_US.UTF-8

#------------All PATHS------------
# GNU coreutils
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# Add local ~/scripts to the PATH
export PATH="$HOME/scripts:$PATH"

# Mason
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# 010 Hex Editor (only if installed)
[[ -d "/Applications/010 Editor.app/Contents/CmdLine" ]] && \
    export PATH="$PATH:/Applications/010 Editor.app/Contents/CmdLine"

# Console Ninja (only if installed)
[[ -d "$HOME/.console-ninja/.bin" ]] && \
    export PATH="$HOME/.console-ninja/.bin:$PATH"

# NVM — lazy-loaded to keep shell startup fast
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm node npm npx
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    nvm "$@"
}
node() { nvm; node "$@"; }
npm()  { nvm; npm  "$@"; }
npx()  { nvm; npx  "$@"; }

# bun — lazy-loaded
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
bun() {
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
    unset -f bun
    bun "$@"
}

#------------Langs------------

# Golang
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Deno (optional — only source if installed)
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

# Python managed via Homebrew — no hardcoded version path

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
