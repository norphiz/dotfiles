bindkey -e
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line

unsetopt PROMPT_SP
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
eval "$(dircolors "$XDG_DATA_HOME/dircolors/src/dir_colors")"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
alias ls='eza -1a --icons=always'
alias gc='git clone -q --depth 1'
alias on='iwctl station wlan0 connect'
alias sdls='sudo eza -1a --icons=always'
alias yy='xclip -selection clipboard -i'
alias off='iwctl station wlan0 disconnect'
alias img='qemu-img create -f qcow2 disk.img'
alias updt-repos='find "$HOME" -name .git | sed s/.git// | xargs -I {} git -C {} pull'
alias updt-mirrors='curl -s https://archlinux.org/mirrorlist/all/ | sudo sed -n "s/#S/S/;w /etc/pacman.d/mirrorlist"'
alias startx='pidof -q Xorg && clear || exec startx /usr/bin/bspwm -- -nolisten local -nolisten tcp > /tmp/startx.log 2>&1'
alias vm='qemu-system-x86_64 -m 2G -smp 2 -M q35 -cpu max -accel kvm -vga virtio -full-screen -hda disk.img -bios /usr/share/edk2/x64/OVMF.4m.fd'

function ex
{
    case "$1" in
        *.zip)
            bsdunzip "$1" ;;
        *.tar.xz | *.tar.gz)
            tar xf "$1" ;;
        *)
            echo 'Usage: ex [FILE]...' ;;
    esac
}

function setup-stuff
{
    local GH="https://github.com" \
        PACK="$XDG_CONFIG_HOME/nvim/pack/plugins/start"

    gc "$GH/nordtheme/vim" "$PACK/vim"

    gc "$GH/norcalli/nvim-colorizer.lua" \
        "$PACK/nvim-colorizer.lua"

    gc "$GH/windwp/nvim-autopairs" "$PACK/nvim-autopairs"

    gc "$GH/nordtheme/dircolors" "$XDG_DATA_HOME/dircolors"

    mkdir -p "$XDG_DATA_HOME/icons/default"

    echo "[Icon Theme]
Inherits=Vanilla-DMZ" > "$XDG_DATA_HOME/icons/default/index.theme"

    sudo pacman -S --needed     \
        eza                     \
        bat                     \
        feh                     \
        gvfs                    \
        rofi                    \
        htop                    \
        xclip                   \
        bspwm                   \
        sxhkd                   \
        neovim                  \
        man-db                  \
        polybar                 \
        redshift                \
        alacritty               \
        ttf-dejavu              \
        noto-fonts              \
        alsa-utils              \
        xorg-xinit              \
        xorg-server             \
        xorg-xinput             \
        pcmanfm-gtk3            \
        xorg-xsetroot           \
        arc-icon-theme          \
        arc-solid-gtk-theme     \
        ttf-nerd-fonts-symbols-mono
}
