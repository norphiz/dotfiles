alias nv='nvim'
alias cl='clear'
alias cp='cp -r'
alias rm='rm -fr'
alias ls='eza -a'
alias cat='bat -pp'
alias sdnv='sudo -e'
alias sdmv='sudo mv'
alias unzip='bsdunzip'
alias psi='pacman -Si'
alias pss='pacman -Ss'
alias pqe='pacman -Qe'
alias pqi='pacman -Qi'
alias pqs='pacman -Qs'
alias pql='pacman -Qlq'
alias sdcp='sudo cp -r'
alias sdls='sudo eza -a'
alias sdrm='sudo rm -fr'
alias pqdt='pacman -Qdtq'
alias inst='sudo pacman -S'
alias pscc='sudo pacman -Scc'
alias updt='sudo pacman -Syu'
alias unst='sudo pacman -Rns'
alias gc='git clone -q --depth 1'
alias on='iwctl station wlan0 connect'
alias off='iwctl station wlan0 disconnect'
alias img='qemu-img create -f qcow2 disk.img'
alias startx='pidof -q Xorg && clear || exec startx -- -nolisten local -nolisten tcp > /tmp/startx.log 2>&1'
alias vm='qemu-system-x86_64 -m 2G -smp 2 -M q35 -cpu max -accel kvm -vga virtio -hda disk.img -bios /usr/share/edk2/x64/OVMF.4m.fd'

updt-plugins()
{
    local INDEX PLUGINS BASE="$HOME/.config/nvim/pack/plugins/start"
    
    PLUGINS=(
        "$BASE/vim"
        "$BASE/nvim-autopairs"
        "$HOME/.local/dircolors"
        "$BASE/nvim-colorizer.lua"
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

    gc "$GH/norcalli/nvim-colorizer.lua" \
        "$PACK/nvim-colorizer.lua"

    gc "$GH/zdharma-continuum/fast-syntax-highlighting" \
        "$ZDOTDIR/fast-syntax-highlighting"
    
    gc "$GH/nordtheme/dircolors" "$HOME/.local/share/dircolors"

    mkdir -p "$HOME/.local/share/icons/default"

    echo '[Icon Theme]
    Inherits=Vanilla-DMZ' > "$HOME/.local/share/icons/default/index.theme"
}

setup-stuff()
{
    local STUFF

    STUFF=(
        eza
        bat
        feh
        gvfs
        rofi
        htop
        xclip
        bspwm
        sxhkd
        neovim
        man-db
        redshift
        alacritty
        man-pages
        xarchiver
        alsa-utils
        xorg-xinit
        noto-fonts
        xorg-server
        xorg-xinput
        pcmanfm-gtk3
        xorg-xsetroot
        arc-gtk-theme
        arc-icon-theme
        zsh-completions
        bash-completions
        archlinux-wallpaper
        xcursor-vanilla-dmz
    )

    sudo pacman -S --needed "${STUFF[@]}"
}
