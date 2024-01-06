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

mkfs.ext4 "$ROOT" > /dev/null

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
    alsa-utils
    arc-gtk-theme
    archlinux-wallpaper
    arc-icon-theme
    bash-completion
    bspwm
    dhcpcd
    efibootmgr
    feh
    git
    grub
    intel-ucode
    iwd
    linux-firmware
    linux-zen
    man-db
    neovim
    noto-fonts
    os-prober
    polybar
    redshift
    sudo
    sxhkd
    terminus-font
    ttf-font-awesome
    vulkan-intel
    vulkan-mesa-layers
    xclip
    xcursor-vanilla-dmz
    xdg-utils
    xorg-server
    xorg-xinit
    xorg-xsetroot
    zsh-completions
    zsh-syntax-highlighting
)

pacstrap /mnt "${PKGS[@]}" > /dev/null

genfstab -U /mnt >> /mnt/etc/fstab

sed -i "s/relatime/noatime/" /mnt/etc/fstab

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

sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen > /dev/null

locale-gen > /dev/null

echo "FONT=ter-128b
KEYMAP=br-abnt2" > /etc/vconsole.conf

echo "install bluetooth /bin/true" > /etc/modprobe.d/blacklist.conf

mkinitcpio -P > /dev/null

read -p "Enter your hostname: " HOST

echo "$HOST" > /etc/hostname

echo "
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOST.localdomain   $HOST" >> /etc/hosts

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

sed -e 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty2"/' \
    -e "s/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/" \
    -e "s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=10/" -i /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch > /dev/null

grub-mkconfig -o /boot/grub/grub.cfg > /dev/null

sed -i "/echo/d" /boot/grub/grub.cfg

mkdir /etc/iwd/

echo "[General]
AddressRandomization=once
AddressRandomizationRange=nic

[Network]
NameResolvingService=resolvconf

# vi: ft=dosini" > /etc/iwd/main.conf

echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/sudoers

systemctl enable iwd > /dev/null

systemctl enable dhcpcd > /dev/null

echo 'Section "InputClass"
    Identifier "Keyboard"
    Option "XkbLayout" "br"
EndSection

Section "InputClass"
    Identifier "Mouse"
    Driver "libinput"
    Option "AccelProfile" "flat"
EndSection

Section "ServerFlags"
    Option "OffTime" "0"
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
EndSection' > /etc/xorg.conf

echo 'source "$HOME/.config/shell/exports"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
source "$XDG_CONFIG_HOME/shell/aliasrc"
wm' > /etc/zsh/zshenv

echo "Successfully installed."

rm "$0"
