updt-plugins() {
    local BASE="$HOME/.config/nvim/pack/plugins/start"
    local PLUGINS=(
        "$BASE/vim"
        "$BASE/nvim-autopairs"
        "$BASE/nvim-treesitter"
        "$HOME/.local/share/wallpaper"
        "$ZDOTDIR/fast-syntax-highlighting"
    )
    for DIR in "${PLUGINS[@]}"
    do
        cd "$DIR"
        git pull
        cd "$HOME"
    done
}

alias nv='nvim'
alias cl='clear'
alias cp='cp -r'
alias rm='rm -fr'
alias ls='eza -a'
alias cat='bat -pp'
alias pqe='pacman -Qe'
alias pql='pacman -Ql'
alias pss='pacman -Ss'
alias pqi='pacman -Qi'
alias psi='pacman -Si'
alias sdls='sudo eza -a'
alias pqdt='pacman -Qdtq'
alias inst='sudo pacman -S'
alias pscc='sudo pacman -Scc'
alias updt='sudo pacman -Syu'
alias unst='sudo pacman -Rns'
alias gc='git clone -q --recursive --depth 1'
alias grep='batgrep --context=0 --no-separator --paging=never'
alias river='clear; pidof -q river && clear || river -no-xwayland'
