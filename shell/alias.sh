update-plugins() {
    local BASE="$HOME/.config/nvim/pack/plugins/start"
    local PLUGINS=(
        "$BASE/dracula.vim"
        "$BASE/nvim-autopairs"
        "$BASE/nvim-treesitter"
        "$BASE/nvim-colorizer.lua"
        "$HOME/.config/zsh/fast-syntax-highlighting"
    )
    for DIR in "${PLUGINS[@]}"
    do
        cd "$DIR"
        git pull
        cd "$HOME"
    done
}

alias nv='nvim'
alias cat='bat'
alias cl='clear'
alias rm='rm -fr'
alias ls='eza -a'
alias grep='batgrep'
alias sdls='sudo eza -a'
alias inst='sudo pacman -S'
alias updt='sudo pacman -Syu'
alias unst='sudo pacman -Rns'
alias gc='git clone -q --recursive --depth 1'
alias sway='clear; sway > .local/share/swaylog 2>&1'
