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
alias sdcp="sudo cp -r"
alias sdrm="sudo rm -fr"
alias sdls="sudo eza -1a"
alias on="iwctl station wlan0 connect"
alias swayimg="swayimg -c info.show=no"
alias off="iwctl station wlan0 disconnect"
alias img="qemu-img create -f qcow2 disk.img"
alias psi="pacman --config ~/.config/pacman/pacman.conf -Si"
alias pss="pacman --config ~/.config/pacman/pacman.conf -Ss"
alias pqs="pacman --config ~/.config/pacman/pacman.conf -Qs"
alias pqe="pacman --config ~/.config/pacman/pacman.conf -Qe"
alias pqi="pacman --config ~/.config/pacman/pacman.conf -Qi"
alias pql="pacman --config ~/.config/pacman/pacman.conf -Qlq"
alias pqdt="pacman --config ~/.config/pacman/pacman.conf -Qqdt"
alias inst="sudo pacman --config ~/.config/pacman/pacman.conf -S"
alias unst="sudo pacman --config ~/.config/pacman/pacman.conf -Rns"
alias river="pidof -q river || exec river -no-xwayland > /dev/null 2>&1"
alias fs="fluidsynth -c 2 -z 256 -a alsa -m alsa_seq -r 48000 /usr/share/soundfonts/FluidR3_GM.sf2"
alias vm="qemu-system-x86_64 -m 2G -smp 2 -M q35 -cpu max -accel kvm -vga virtio -full-screen -hda disk.img -bios /usr/share/edk2/x64/OVMF.4m.fd"

updt()
{
    case "$1" in
        -r)
            curl -s -f "https://archlinux.org/mirrorlist/all/https/" | sed -n "s/#S/S/ ; w $XDG_CONFIG_HOME/pacman/mirrorlist" ;;
        -g)
            find "$HOME" -name ".git" | sed "s/.git//" | xargs -I {} git -C {} pull ;;
        -a)
            sudo pacman --config "$XDG_CONFIG_HOME/pacman/pacman.conf" -Syu
            find "$HOME" -name ".git" | sed "s/.git//" | xargs -I {} git -C {} pull ;;
        *)
            sudo pacman --config "$XDG_CONFIG_HOME/pacman/pacman.conf" -Syu ;;
    esac
}

setup-stuff()
{
    local GH PACK PKGS

    GH="https://github.com"
    
    PACK="$XDG_CONFIG_HOME/nvim/pack/plugins/start"

    PKGS=("eza"
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
          "wl-clipboard"
          "pipewire-alsa"
          "noto-fonts-cjk"
          "noto-fonts-extra"
          "noto-fonts-emoji"
          "xcursor-vanilla-dmz"
          "ttf-nerd-fonts-symbols-mono"
          "tela-circle-icon-theme-dracula")
    
    gc "$GH/dracula/vim" "$PACK/vim"

    gc "$GH/windwp/nvim-autopairs" "$PACK/nvim-autopairs"

    gc "$GH/zdharma-continuum/fast-syntax-highlighting" \
        "$ZDOTDIR/fast-syntax-highlighting"

    mkdir -p "$XDG_DATA_HOME/wallpaper"

    curl 'https://raw.githubusercontent.com/dracula/wallpaper/refs/heads/master/first-collection/base.png' \
        -o "$XDG_DATA_HOME/wallpaper/base.png"

    sudo pacman -S --needed "${PKGS[@]}"
}
