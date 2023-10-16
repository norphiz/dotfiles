#!/bin/bash

set -e

cfdisk

clear

lsblk

read -p 'Enter boot partition: ' BOOT

read -p 'Enter swap partition: ' SWAP

read -p 'Enter root partition: ' ROOT

mkfs.fat -F 32 "$BOOT"

mkswap "$SWAP"

swapon "$SWAP"

mkfs.ext4 "$ROOT"

clear

mount "$ROOT" /mnt

mkdir -p /mnt/boot/arch

mount "$BOOT" /mnt/boot/arch

read -n1 -p 'Do you have a Windows(R) boot partition? [Y/n]: ' WIN

if test -z "$WIN"; then
    lsblk
    mkdir /mnt/boot/windows/
    read -p 'Enter Windows(R) boot partition: ' WINBOOT
    mount "$WINBOOT" /mnt/boot/windows/
else
    clear
fi

pacstrap /mnt base linux-zen linux-firmware grub os-prober efibootmgr neovim iwd dhcpcd bspwm polybar sxhkd xorg-server xorg-xinit xorg-xsetroot ttf-font-awesome man-db arc-gtk-theme arc-icon-theme xclip alsa-utils feh noto-fonts sudo xcursor-vanilla-dmz git alacritty intel-ucode archlinux-wallpaper redshift bash-completion zsh-syntax-highlighting zsh-completions terminus-font

clear

genfstab -U /mnt >> /mnt/etc/fstab

sed -i 's/relatime/noatime/' /mnt/etc/fstab

sed -n '/^hwclock/,$p' "$0" > /mnt/chroot.sh

chmod +x /mnt/chroot.sh

arch-chroot /mnt ./chroot.sh

hwclock -w

echo '[options]
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
#Include = /etc/pacman.d/mirrorlist' > /etc/pacman.conf

sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen

locale-gen

echo 'FONT=ter-128b
KEYMAP=br-abnt2' > /etc/vconsole.conf

echo 'install bluetooth /bin/true' > /etc/modprobe.d/blacklist.conf

mkinitcpio -P

clear

read -p 'Enter your hostname: ' HOST

echo "$HOST" > /etc/hostname

echo "
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOST.localdomain   $HOST" >> /etc/hosts

read -p 'Enter your username: ' NAME

useradd -mG wheel,audio,video "$NAME" -s /bin/zsh

echo 'Enter user password'

passwd "$NAME"

rm /home/"$NAME"/.bash*

git clone --depth=1 https://github.com/norphiz/dotfiles.git

mv dotfiles/ /home/"$NAME"/.config/

rm /home/"$NAME"/.config/LICENSE

rm /home/"$NAME"/.config/README.md

rm -fr /home/"$NAME"/.config/.git/

clear

chmod +x /home/"$NAME"/.config/bspwm/bspwmrc

mkdir -p /home/"$NAME"/.local/share/icons/default/

echo '[Icon Theme]
Inherits=Vanilla-DMZ' > /home/"$NAME"/.local/share/icons/default/index.theme

fc-cache -f

chown "$NAME" -R /home/"$NAME"/

chgrp "$NAME" -R /home/"$NAME"/

sed -e 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty2"/' -e 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' -e 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=10/' -i /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot/arch --bootloader-id=Arch

grub-mkconfig -o /boot/grub/grub.cfg

clear

sed -i '/echo/d' /boot/grub/grub.cfg

mkdir /etc/iwd/

echo '[General]
AddressRandomization=once
AddressRandomizationRange=nic

[Network]
NameResolvingService=resolvconf

# vi: ft=dosini' > /etc/iwd/main.conf

echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/sudoers

systemctl enable iwd

systemctl enable dhcpcd

echo 'Section "ServerFlags"
    Option "OffTime" "0"
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
EndSection

Section "InputClass"
    Identifier "Mouse0"
    Driver "libinput"
    Option "AccelSpeed" "0"
    Option "AccelProfile" "flat"
EndSection' > /etc/xorg.conf

echo 'source "$HOME/.config/shell/exports"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
source "$XDG_CONFIG_HOME/shell/aliasrc"
wm' > /etc/zsh/zshenv

rm "$0"
