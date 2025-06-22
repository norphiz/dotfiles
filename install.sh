#!/usr/bin/bash

set -eu

PACKAGES=("base"
          "sudo"
          "linux"
          "dhcpcd"
          "intel-ucode"
          "glibc-locales"
          "xdg-user-dirs"
          "zram-generator"
          "zsh-completions")

cfdisk && clear

lsblk

read -r -p "Enter esp and root partition: " -a PARTITIONS

read -r -p "Are you dual booting? [y/n]: " DUALBOOT

read -r -p "Install linux-firmware? [y/n]: " FIRMWARE

mkfs.ext4 -q "${PARTITIONS[1]}" && mount "${PARTITIONS[1]}" /mnt

test "${FIRMWARE,,}" = "y" && PACKAGES+=("iwd" "wireless-regdb" "linux-firmware-intel")

if test "${DUALBOOT,,}" = "y"; then
    read -r -p "Enter boot partition: " BOOT

    mkfs.fat -F 32 "$BOOT" > /dev/null

    mount -m -o umask=0077 "${PARTITIONS[0]}" /mnt/efi

    mount -m "$BOOT" /mnt/boot

    bootctl --esp-path=/mnt/efi --boot-path=/mnt/boot install > /dev/null 2>&1

    echo "timeout 10" > /mnt/efi/loader/loader.conf
elif test "${DUALBOOT,,}" = "n"; then
    mkfs.fat -F 32 "${PARTITIONS[0]}" > /dev/null

    mount -m -o umask=0077 "${PARTITIONS[0]}" /mnt/boot
    
    bootctl --esp-path=/mnt/boot install > /dev/null 2>&1
else
    exit 1
fi

pacstrap -i -K /mnt "${PACKAGES[@]}" && clear

if test "${FIRMWARE,,}" = "y"; then
    arch-chroot /mnt systemctl enable iwd

    mkdir /mnt/etc/iwd

    echo "[General]
AddressRandomization=once
AddressRandomizationRange=full" > /mnt/etc/iwd/main.conf
fi

read -r -p "Enter username: " NAME

useradd -m -R /mnt -G wheel -k /dev/null -s /usr/bin/zsh "$NAME"

passwd -R /mnt "$NAME" && clear

genfstab -U /mnt >> /mnt/etc/fstab

ln -s /usr/share/zoneinfo/America/Fortaleza /mnt/etc/localtime

arch-chroot /mnt systemctl disable systemd-userdbd

arch-chroot /mnt systemctl enable dhcpcd systemd-boot-update

echo "arch" > /mnt/etc/hostname

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

echo "KEYMAP=br-abnt2" > /mnt/etc/vconsole.conf

echo "$NAME ALL=(ALL:ALL) ALL" > /mnt/etc/sudoers.d/sudoers

echo 'export ZDOTDIR="$HOME/.config/zsh"' > /mnt/etc/zsh/zshenv

echo "[zram0]
compression-algorithm = zstd" > /mnt/etc/systemd/zram-generator.conf

echo "title Arch Linux
linux vmlinuz-linux
initrd intel-ucode.img
initrd booster-linux.img
options root=UUID=$(blkid "${PARTITIONS[1]}" -s UUID -o value) rw quiet" > /mnt/boot/loader/entries/arch.conf

umount -R /mnt
