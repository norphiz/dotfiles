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
alias yy="xclip -selection clip -i"
alias pp="xclip -selection clip -o"
alias on="iwctl station wlan0 connect"
alias off="iwctl station wlan0 disconnect"
alias img="qemu-img create -f qcow2 disk.img"
alias startx="pidof -q Xorg || exec startx /usr/bin/bspwm -- -logfile /dev/null -nolisten tcp -nolisten local > /dev/null 2>&1"
alias vm="qemu-system-x86_64 -m 2G -smp 2 -M q35 -cpu max -accel kvm -vga virtio -full-screen -hda disk.img -bios /usr/share/edk2/x64/OVMF.4m.fd"

updt()
{
    case "$1" in
        -g)
            find "$HOME" -name ".git" | sed "s/.git//" | xargs -I {} git -C {} pull ;;
        -m)
            curl -s "https://archlinux.org/mirrorlist/all/https/" | sudo sed -n "s/#S/S/ ; w /etc/pacman.d/mirrorlist" ;;
        -a)
            curl -s "https://archlinux.org/mirrorlist/all/https/" | sudo sed -n "s/#S/S/ ; w /etc/pacman.d/mirrorlist"
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
                "feh"
                "rofi"
                "htop"
                "gvfs"
                "scrot"
                "xclip"
                "bspwm"
                "sxhkd"
                "man-db"
                "neovim"
                "polybar"
                "starship"
                "xarchiver"
                "xdg-utils"
                "alacritty"
                "dosfstools"
                "alsa-utils"
                "xorg-xinit"
                "xorg-server"
                "pcmanfm-gtk3"
                "ttf-croscore"
                "polkit-gnome"
                "xorg-xsetroot"
                "noto-fonts-cjk"
                "noto-fonts-extra"
                "noto-fonts-emoji"
                "papirus-icon-theme"
                "xcursor-vanilla-dmz"
                "ttf-nerd-fonts-symbols-mono")
    
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

    mkdir -p "$XDG_DATA_HOME/icons/default"

    echo "Inherits=Vanilla-DMZ" > "$XDG_DATA_HOME/icons/default/index.theme"

    sudo echo 'Section "ServerFlags"
    Option "BlankTime" "0"
EndSection

Section "InputClass"
    Identifier "Mouse"
    Driver "libinput"
    Option "AccelProfile" "flat"
EndSection

Section "InputClass"
    Identifier "Keyboard"
    Option "XkbLayout" "br,us"
    Option "XkbOptions" "grp:win_space_toggle"
EndSection' > /etc/xorg.conf
}
