#!/bin/bash

set -e

cfdisk

clear

lsblk

read -p "Enter boot partition: " BOOT

read -p "Enter swap partition: " SWAP

read -p "Enter root partition: " ROOT

mkfs.fat -F 32 "$BOOT" > /dev/null

mkswap "$SWAP" > /dev/null

swapon "$SWAP"

mkfs.ext4 -L ROOT "$ROOT" > /dev/null

mount "$ROOT" /mnt

mkdir /mnt/boot

mount "$BOOT" /mnt/boot

lsblk

read -p "Enter Windows(R) boot partiton: " WINBOOT

mkdir /mnt/boot/windows

mount "$WINBOOT" /mnt/boot/windows

echo "Installing base system."

PKGS=(
    base
    alacritty
    alsa{-utils,-plugins}
    arc{-gtk-theme,-icon-theme}
    archlinux-wallpaper
    bash-completion
    bspwm
    dhcpcd
    efibootmgr
    feh
    git
    intel-ucode
    iwd
    linux{-zen,-firmware}
    man-db
    neovim
    noto-fonts{,-extra,-emoji,}
    polybar
    redshift
    sudo
    sxhkd
    speexdsp
    terminus-font
    ttf-font-awesome
    ttf-joypixels
    xclip
    xcursor-vanilla-dmz
    xdg-utils
    xorg{-server,-xinit,-xsetroot}
    zsh{-completions,-syntax-highlighting}
)

pacstrap -K /mnt "${PKGS[@]}" > /dev/null

genfstab -U /mnt >> /mnt/etc/fstab

sed -e "s/relatime/noatime/" \
    -e "s/fmask=0022/fmask=0137/" \
    -e "s/dmask=0022/dmask=0027/" -i /mnt/etc/fstab

sed -n '/^hwclock/,$p' "$0" > /mnt/chroot.sh

arch-chroot /mnt bash /chroot.sh

hwclock -w

echo "[options]
Color
CheckSpace
ILoveCandy
CacheDir = /tmp/
Architecture = auto
ParallelDownloads = 5
DisableDownloadTimeout
HoldPkg = pacman glibc
LocalFileSigLevel = Optional
SigLevel = Required DatabaseOptional

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

#[multilib]
#Include = /etc/pacman.d/mirrorlist" > /etc/pacman.conf

echo 'defaults.pcm.rate_converter "speexrate_medium"' > /etc/asound.conf

sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen > /dev/null

locale-gen > /dev/null

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "FONT=ter-128b
KEYMAP=br-abnt2" > /etc/vconsole.conf

echo "install bluetooth /bin/true" > /etc/modprobe.d/blacklist.conf

mkinitcpio -P > /dev/null

read -p "Enter your hostname: " HOST

echo "$HOST" > /etc/hostname

read -p "Enter your username: " NAME

useradd -mG wheel,audio,video "$NAME" -s /bin/zsh

echo "Enter user password"

passwd "$NAME"

cd /home/"$NAME"

rm .*

git clone --depth=1 https://github.com/norphiz/dotfiles .config > /dev/null

rm -fr .config/{.git,README.md,LICENSE}

chmod +x .config/bspwm/bspwmrc

mkdir -p .local/share/icons/default

echo "[Icon Theme]
Inherits=Vanilla-DMZ" > .local/share/icons/default/index.theme

chown -R "$NAME:$NAME" /home/"$NAME"

fc-cache -f

sed -i "/echo/d" /boot/grub/grub.cfg

mkdir /etc/iwd/

echo "[General]
AddressRandomization=once
AddressRandomizationRange=full

[Network]
NameResolvingService=resolvconf

# vi: ft=dosini" > /etc/iwd/main.conf

echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/sudoers

bootctl install > /dev/null 2>&1

echo "default arch.conf
timeout 10
console-mode max
editor no" > /boot/loader/loader.conf

echo "title Arch Linux
linux vmlinuz-linux-zen
initrd initramfs-linux-zen.img
initrd intel-ucode.img
options root=LABEL=ROOT rw quiet console=tty2" > /boot/loader/entries/arch.conf

systemctl enable systemd-boot-update > /dev/null

systemctl enable iwd > /dev/null

systemctl enable dhcpcd > /dev/null

echo 'Section "InputClass"
    Identifier "Keyboard"
    Option "XkbLayout" "br"
EndSection

Section "ServerFlags"
    Option "OffTime" "0"
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
EndSection' > /etc/xorg.conf

echo 'export ZDOTDIR="$HOME/.config/zsh/"' > /etc/zsh/zshenv

echo "Successfully installed."

rm "$0"
