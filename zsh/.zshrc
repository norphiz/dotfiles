bindkey -e
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line

unsetopt promptsp
eval "$(dircolors -b)"
setopt autocd correct globdots
autoload -U compinit && compinit
zstyle ":completion:*" menu select
source "$ZDOTDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

alias nv='nvim'
alias cl='clear'
alias cp='cp -r'
alias rm='rm -fr'
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
alias sdrm='sudo rm -fr'
alias pqdt='pacman -Qdtq'
alias inst='sudo pacman -S'
alias updt='sudo pacman -Syu'
alias unst='sudo pacman -Rns'
alias ls='eza -1a --icons=auto'
alias lf='XDG_DATA_HOME=/tmp lf'
alias gc='git clone -q --depth 1'
alias yy='xclip -selection clip -i'
alias on='iwctl station wlan0 connect'
alias sdls='sudo eza -1a --icons=auto'
alias off='iwctl station wlan0 disconnect'
alias img='qemu-img create -f qcow2 disk.img'
alias updt-repos='find ~ -name .git | sed s/.git// | xargs -I {} git -C {} pull'
alias startx='pidof -q Xorg || exec startx /usr/bin/bspwm -- -nolisten local -nolisten tcp > /dev/null 2>&1'
alias updt-mirrors='curl -s https://archlinux.org/mirrorlist/all/https/ | sudo sed -n "s/#S/S/; w /etc/pacman.d/mirrorlist"'
alias vm='qemu-system-x86_64 -m 2G -smp 2 -M q35 -cpu max -accel kvm -vga virtio -full-screen -hda disk.img -bios /usr/share/edk2/x64/OVMF.4m.fd'

setup-pkgs()
{
    local PKGS=("lf"
                "eza"
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
                "xdg-utils"
                "man-pages"
                "alacritty"
                "dosfstools"
                "alsa-utils"
                "xorg-xinit"
                "ttf-dejavu"
                "xorg-server"
                "pcmanfm-gtk3"
                "ttf-croscore"
                "polkit-gnome"
                "xorg-xsetroot"
                "noto-fonts-cjk"
                "noto-fonts-extra"
                "noto-fonts-emoji"
                "xcursor-vanilla-dmz"
                "archlinux-wallpaper"
                "zsh-syntax-highlighting"
                "ttf-nerd-fonts-symbols-mono")
    
    sudo pacman -S --needed "${PKGS[@]}"
}

setup-stuff()
{
    local GH PACK

    GH="https://github.com"
    
    PACK="$XDG_CONFIG_HOME/nvim/pack/plugins/start"

    gc "$GH/nordtheme/vim" "$PACK/vim"

    gc "$GH/windwp/nvim-autopairs" "$PACK/nvim-autopairs"

    gc "$GH/zdharma-continuum/fast-syntax-highlighting" \
        "$ZDOTDIR/fast-syntax-highlighting"

    mkdir -p "$XDG_DATA_HOME/icons/default"

    echo "Inherits=Vanilla-DMZ" > "$XDG_DATA_HOME/icons/default/index.theme"

    sudo echo 'Section "Extensions"
    Option "DPMS" "0"
EndSection

Section "ServerFlags"
    Option "BlankTime" "0"
EndSection

Section "InputClass"
    Identifier "Mouse"
    Driver "libinput"
    Option "AccelProfile" "flat"
EndSection

Section "InputClass"
    Identifier "Keyboard"
    Option "XkbModel" "abnt2"
    Option "XkbLayout" "br,us"
    Option "XkbOptions" "grp:win_space_toggle"
EndSection' > /etc/xorg.conf
}
