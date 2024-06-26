updt-plugins() {
    local BASE="$HOME/.config/nvim/pack/plugins/start"
    local PLUGINS=(
        "$BASE/vim"
        "$BASE/mini.nvim"
        "$BASE/nvim-treesitter"
        "$HOME/.local/share/wallpaper"
        "$ZDOTDIR/fast-syntax-highlighting"
    )
    local INDEX
    for INDEX in "${PLUGINS[@]}"
    do
        git -C "$INDEX" pull
    done
}

alias nv='nvim'
alias cl='clear'
alias cp='cp -r'
alias rm='rm -fr'
alias ls='eza -a'
alias cat='bat -pp'
alias sdnv='sudo -e'
alias sdmv='sudo mv'
alias psi='pacman -Si'
alias pss='pacman -Ss'
alias pqe='pacman -Qe'
alias pqi='pacman -Qi'
alias pqs='pacman -Qs'
alias pql='pacman -Qlq'
alias sdcp='sudo cp -r'
alias sdls='sudo eza -a'
alias pqdt='pacman -Qdtq'
alias inst='sudo pacman -S'
alias pscc='sudo pacman -Scc'
alias updt='sudo pacman -Syu'
alias unst='sudo pacman -Rns'
alias gc='git clone -q --recursive --depth 1'
alias grep='batgrep --context=0 --no-separator --paging=never'
alias start-river='pidof -q river || exec river -no-xwayland -log-level error && clear || clear'
alias start-bspwm='pidof -q bspwm || XAUTHORITY="$HOME/.local/share/Xauthority" exec startx /usr/bin/bspwm -- -quiet && clear || clear'
