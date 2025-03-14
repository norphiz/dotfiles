#!/usr/bin/bash

set -eu

clear

PACKAGES=(
    sudo
    linux
    dhcpcd
    booster
    intel-ucode
    glibc-locales
    xdg-user-dirs
    linux-firmware
    zram-generator
    zsh-completions
    zsh-syntax-highlighting
)

lsblk

read -r -p "Enter uefi partition: " UEFI

read -r -p "Enter root partition: " ROOT

mkfs.ext4 -q "$ROOT"

mount "$ROOT" /mnt

pacstrap -K /mnt

clear

echo "arch" > /mnt/etc/hostname

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

echo "KEYMAP=br-abnt2" > /mnt/etc/vconsole.conf

echo "[zram0]
compression-algorithm = zstd" > /mnt/etc/systemd/zram-generator.conf

read -r -p 'Are you dual booting? [y/n]: ' ANSWER

if test "${ANSWER,,}" = 'y'; then 
    lsblk

    read -r -p "Enter boot partition: " BOOT

    mkfs.fat -F 32 "$BOOT" > /dev/null 2>&1

    mount "$BOOT" /mnt/boot

    mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

    bootctl install --esp-path=/mnt/efi --boot-path=/mnt/boot > /dev/null 2>&1

    echo "editor no
    timeout 10" > /mnt/efi/loader/loader.conf

    echo "title Arch Linux
    linux vmlinuz-linux
    initrd intel-ucode.img
    initrd booster-linux.img
    options root=UUID=$(blkid "$ROOT" -s UUID -o value) rw quiet" > /mnt/boot/loader/entries/arch.conf
elif test "${ANSWER,,}" = 'n'; then
    mkfs.fat -F 32 "$UEFI" > /dev/null 2>&1

    mount -o fmask=0077,dmask=0077 "$UEFI" /mnt/boot

    bootctl install --esp-path=/mnt/boot > /dev/null 2>&1

    ln -s /usr/share/zoneinfo/America/Fortaleza /mnt/etc/localtime

    echo "title Arch Linux
    linux vmlinuz-linux
    initrd intel-ucode.img
    initrd booster-linux.img
    options root=UUID=$(blkid "$ROOT" -s UUID -o value) rw quiet" > /mnt/boot/loader/entries/arch.conf
else
    return 1
fi

genfstab -U /mnt >> /mnt/etc/fstab

echo "Packages to be installed: ${PACKAGES[*]}"

read -r -p "Enter extra packages to be installed: " -a EXTRA

PACKAGES+=("${EXTRA[@]}")

pacstrap /mnt "${PACKAGES[@]}"

clear

read -r -p "Enter username: " NAME

useradd -m -R /mnt -G wheel -k /dev/null -s /usr/bin/zsh "$NAME"

passwd -R /mnt "$NAME"

clear

echo "$NAME ALL=(ALL:ALL) ALL" > /mnt/etc/sudoers.d/sudoers

echo 'export ZDOTDIR="$HOME/.config/zsh"' > /mnt/etc/zsh/zshenv

if test -e /mnt/usr/bin/iwctl; then
    pacstrap /mnt wireless-regdb

    arch-chroot /mnt systemctl -q enable iwd

    mkdir /mnt/etc/iwd

    echo "[General]
AddressRandomization=once
AddressRandomizationRange=full" > /mnt/etc/iwd/main.conf
fi

arch-chroot /mnt systemctl -q enable dhcpcd systemd-boot-update

arch-chroot /mnt systemctl -q disable systemd-userdbd.socket

umount -R /mnt
