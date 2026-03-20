# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"
export TEALDEER_CONFIG_DIR="$HOME/.config/tealdeer/"

fpath=(~/.zsh/completions $fpath)

plugins=(
    git
    zsh-syntax-highlighting
    zsh-system-clipboard
)

source $ZSH/oh-my-zsh.sh

#----- Vim editing mode & keymaps ------
set -o vi

export EDITOR=nvim
export VISUAL=nvim

bindkey -M viins '^P' up-line-or-beginning-search
bindkey -M viins '^N' down-line-or-beginning-search
#---------------------------------------

# FZF
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_TMUX_OPTS=" -p90%,70% "

bindkey -r "^G"

# Initializers and sources
eval "$(gdircolors)"

# wtp — guarded: only init if installed
command -v wtp &>/dev/null && eval "$(wtp shell-init zsh)"

# gitbutler CLI — guarded: only init if installed
command -v but &>/dev/null && eval "$(but completions zsh)"

# starship
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi
eval "$(starship init zsh)"

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
source ~/scripts/fzf-git.sh

# Atuin
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
bindkey '^r' atuin-search-viins

# Sesh tmux session picker
function sesh-sessions() {
    {
        exec </dev/tty
        exec <&1
        local session
        session=$(sesh list -t -c | fzf --height 50% --border-label ' sesh ' --border --prompt '🛸  ')
        zle reset-prompt > /dev/null 2>&1 || true
        [[ -z "$session" ]] && return
        sesh connect $session
    }
}
zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# -------------------ALIAS----------------------
alias air='$(go env GOPATH)/bin/air'
alias c="clear"
alias e="exit"
alias vim="nvim"

# Tmux
alias tmux="tmux -f $TMUX_CONF"
alias a="attach"
alias tns="~/scripts/tmux-sessionizer.sh"

# fzf helpers
alias nlof="~/scripts/fzf_listoldfiles.sh"
alias fman="compgen -c | fzf | xargs man"

# zoxide
alias nzo="~/scripts/zoxide_openfiles_nvim.sh"

# ls
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"

# tree
alias tree="tree -L 3 -a -I '.git' --charset X "
alias dtree="tree -L 3 -a -d -I '.git' --charset X "

# lstr
alias lstr="lstr --icons"

# git
alias gt="git"
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'
alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

alias nvim-scratch="NVIM_APPNAME=nvim-scratch nvim"
alias lg="lazygit"
alias myvault="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/"

# brew path
typeset -U PATH
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
