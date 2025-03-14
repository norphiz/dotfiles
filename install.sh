#!/bin/bash

set -eu

clear

PACKAGES=(
    sudo
    linux
    dhcpcd
    intel-ucode
    glibc-locales
    xdg-user-dirs
    linux-firmware
    zram-generator
    zsh-completions
    zsh-syntax-highlighting
)

lsblk

read -r -p "Enter the uefi partition: " UEFI

read -r -p "Enter the root partition: " ROOT

mkfs.ext4 -q "$ROOT"

mount "$ROOT" /mnt

reflector -a 1 -c br -p https --sort rate --save /etc/pacman.d/mirrorlist

pacstrap -K /mnt

clear

read -r -p "Enter username: " NAME

clear

useradd -m -R /mnt -G wheel -k /dev/null -s /usr/bin/zsh "$NAME"

passwd -R /mnt "$NAME"

clear

genfstab -U /mnt >> /mnt/etc/fstab

echo "arch" > /mnt/etc/hostname

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

echo "KEYMAP=br-abnt2" > /mnt/etc/vconsole.conf

echo "[zram0]
compression-algorithm = zstd" > /mnt/etc/systemd/zram-generator.conf

echo "Packages to be installed: ${PACKAGES[*]}"

read -r -p "Enter extra packages to be installed: " -a EXTRA

clear

PACKAGES+=("${EXTRA[@]}")

pacstrap /mnt "${PACKAGES[@]}"

clear

echo "$NAME ALL=(ALL:ALL) ALL" > /mnt/etc/sudoers.d/sudoers

echo 'export ZDOTDIR="$HOME/.config/zsh"' > /mnt/etc/zsh/zshenv

ln -s /usr/lib/systemd/system/dhcpcd.service /mnt/etc/systemd/system/multi-user.target.wants

rm -fr /mnt/etc/systemd/system/sockets.target.wants

if test -e /usr/bin/iwctl; then

    pacstrap /mnt wireless-regdb
    
    ln -s /usr/lib/systemd/system/iwd.service /mnt/etc/systemd/system/multi-user.target.wants

    mkdir /mnt/etc/iwd

    echo "[General]
AddressRandomization=once
AddressRandomizationRange=full" > /mnt/etc/iwd/main.conf
fi

while true; do

    read -r -p "Are you dual booting? [N/y]: " DUAL

    case "$DUAL" in
        [yY])
            lsblk

            read -r -p "Enter boot partition: " BOOT

            mkfs.fat -F 32 "$BOOT" > /dev/null 2>&1

            mount "$BOOT" /mnt/boot

            mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

            bootctl -q --esp-path=/mnt/efi --boot-path=/mnt/boot install > /dev/null 2>&1

            echo "editor no
            timeout 10" > /mnt/efi/loader/loader.conf

            echo "title Arch Linux
            linux vmlinuz-linux
            initrd intel-ucode.img
            initrd booster-linux.img
            options root=UUID=$(blkid "$ROOT" -s UUID -o value) rw quiet" > /mnt/boot/loader/entries/arch.conf ;;
        [nN])
            mkfs.fat -F 32 "$UEFI" > /dev/null 2>&1

            mount -o fmask=0077,dmask=0077 "$UEFI" /mnt/boot

            bootctl -q --esp-path=/mnt/boot install > /dev/null 2>&1

            ln -s /usr/share/zoneinfo/America/Fortaleza /mnt/etc/localtime

            echo "title Arch Linux
            linux vmlinuz-linux
            initrd intel-ucode.img
            initrd booster-linux.img
            options root=UUID=$(blkid "$ROOT" -s UUID -o value) rw quiet" > /mnt/boot/loader/entries/arch.conf ;;
    esac
done

umount -R /mnt

reboot
