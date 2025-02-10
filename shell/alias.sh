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
alias gc='git clone -q --depth 1'
alias start-river='pidof -q river && clear || exec river -no-xwayland'

updt-plugins()
{
    local INDEX BASE="$HOME/.config/nvim/pack/plugins/start" \
        PLUGINS=(
            "$BASE/vim"
            "$BASE/nvim-autopairs"
            "$HOME/.local/share/wallpaper"
            "$ZDOTDIR/fast-syntax-highlighting"
        )

    for INDEX in "${PLUGINS[@]}"
    do
        git -C "$INDEX" pull
    done
}

setup-plugins()
{
    local GH="https://github.com" \
        PACK="$HOME/.config/nvim/pack/plugins/start"

    gc "$GH/dracula/vim" "$PACK/vim"
    
    gc "$GH/nvim-treesitter/nvim-treesitter" \
        "$PACK/nvim-treesitter"

    gc "$GH/windwp/nvim-autopairs" "$PACK/nvim-autopairs"

    gc "$GH/zdharma-continuum/fast-syntax-highlighting" \
        "$ZDOTDIR/fast-syntax-highlighting"
    
    gc "$GH/dracula/wallpaper" "$HOME/.local/share/wallpaper"
}
