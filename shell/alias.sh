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
alias start-labwc='pidof -q labwc && clear || exec labwc > /tmp/labwc.log 2>&1'

updt-plugins()
{
    local INDEX PLUGINS BASE="$HOME/.config/nvim/pack/plugins/start"
    
    PLUGINS=(
        "$BASE/vim"
        "$BASE/nvim-autopairs"
        "$HOME/.local/share/dircolors"
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

    gc "$GH/nordtheme/vim" "$PACK/vim"

    gc "$GH/windwp/nvim-autopairs" "$PACK/nvim-autopairs"

    gc "$GH/zdharma-continuum/fast-syntax-highlighting" \
        "$ZDOTDIR/fast-syntax-highlighting"
    
    gc "$GH/nordtheme/dircolors" "$HOME/.local/share/dircolors"
}

setup-stuff()
{
    local STUFF

    STUFF=(
        git
        eza
        bat
        foot
        wofi
        labwc
        neovim
        man-db
        swaybg
        firefox
        man-pages
        wl-clipboard
        arc-gtk-theme
        arc-icon-theme
        zsh-completions
        bash-completions
        archlinux-wallpaper
        xcursor-vanilla-dmz
        firefox-ublock-origin
    )

    sudo pacman -S --needed "${STUFF[@]}"
}
