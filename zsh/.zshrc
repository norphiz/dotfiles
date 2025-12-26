bindkey -e
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line

setopt globdots
unsetopt promptsp
eval "$(dircolors)"
eval "$(starship init zsh)"
autoload -U compinit && compinit
zstyle ":completion:*" menu select
source "$ZDOTDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

alias nv="nvim"
alias cl="clear"
alias cp="cp -r"
alias rm="rm -fr"
alias ls="eza -1a"
alias cat="bat -pp"
alias sdnv="sudo -e"
alias sdmv="sudo mv"
alias gc="git clone"
alias psi="pacman -Si"
alias pss="pacman -Ss"
alias pqs="pacman -Qs"
alias pqe="pacman -Qe"
alias pqi="pacman -Qi"
alias pql="pacman -Qlq"
alias sdcp="sudo cp -r"
alias sdrm="sudo rm -fr"
alias pqdt="pacman -Qqdt"
alias sdls="sudo eza -1a"
alias inst="sudo pacman -S"
alias unst="sudo pacman -Rns"
alias on="iwctl station wlan0 connect"
alias swayimg="swayimg -c info.show=no"
alias off="iwctl station wlan0 disconnect"
alias img="qemu-img create -f qcow2 disk.img"
alias river="pidof -q river || exec river -no-xwayland > /dev/null 2>&1"
alias vm="qemu-system-x86_64 -m 2G -smp 2 -M q35 -cpu max -accel kvm -vga virtio -full-screen -hda disk.img -bios /usr/share/edk2/x64/OVMF.4m.fd"

updt()
{
    case "$1" in
        -r)
            curl -s -f "https://archlinux.org/mirrorlist/all/https/" | sudo sed -n "s/#S/S/ ; w /etc/pacman.d/mirrorlist" ;;
        -g)
            find "$HOME" -name ".git" | sed "s/.git//" | xargs -I {} git -C {} pull ;;
        -a)
            find "$HOME" -name ".git" | sed "s/.git//" | xargs -I {} git -C {} pull
            sudo pacman -Syu ;;
        *)
            sudo pacman -Syu ;;
    esac
}

setup-pkgs()
{
    local PKGS=("eza"
                "bat"
                "htop"
                "grim"
                "wofi"
                "river"
                "slurp"
                "swaybg"
                "man-db"
                "neovim"
                "waybar"
                "swayimg"
                "pcmanfm"
                "gvfs-mtp"
                "starship"
                "xarchiver"
                "xdg-utils"
                "alacritty"
                "dosfstools"
                "alsa-utils"
                "ttf-croscore"
                "polkit-gnome"
                "pipewire-alsa"
                "noto-fonts-cjk"
                "noto-fonts-extra"
                "noto-fonts-emoji"
                "xcursor-vanilla-dmz"
                "ttf-nerd-fonts-symbols-mono"
                "tela-circle-icon-theme-dracula")
    
    sudo pacman -S --needed "${PKGS[@]}"
}

setup-stuff()
{
    local GH PACK

    GH="https://github.com"
    
    PACK="$XDG_CONFIG_HOME/nvim/pack/plugins/start"

    gc "$GH/dracula/vim" "$PACK/vim"

    gc "$GH/dracula/wallpaper" "$XDG_DATA_HOME/wallpaper"

    gc "$GH/windwp/nvim-autopairs" "$PACK/nvim-autopairs"

    gc "$GH/zdharma-continuum/fast-syntax-highlighting" \
        "$ZDOTDIR/fast-syntax-highlighting"
}
