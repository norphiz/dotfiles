#!/usr/bin/bash

set -eu

PKGS=("base" "sudo" "linux" "dhcpcd" "booster" "glibc-locales" "zram-generator")

cfdisk && clear

lsblk

read -r -p "Enter esp and root partition: " -a PARTITIONS && clear

read -r -p "Are you dual booting? [y/n]: " DUALBOOT

if test "${DUALBOOT,,}" = "y"; then
    read -rp "Enter boot partition: " BOOT

    mkfs.fat -F 32 "$BOOT" > /dev/null

    mkfs.ext4 -q "${PARTITIONS[1]}"

    mount "${PARTITIONS[1]}" /mnt

    mount -m -o fmask=0077,dmask=0077 "${PARTITIONS[0]}" /mnt/efi

    mount -m "$BOOT" /mnt/boot

    read -rp "Install linux-firmware? [y/n]: " FIRMWARE

    if test "${FIRMWARE,,}" = "y"; then
        PKGS+=("iwd" "linux-firmware" "wireless-regdb")
    fi

    pacstrap -K /mnt "${PKGS[@]}"

    bootctl install --esp-path=/mnt/efi --boot-path=/mnt/boot > /dev/null

    echo "timeout 10" > /mnt/efi/loader/loader.conf

    echo "title Arch Linux
linux vmlinuz-linux
initrd intel-ucode.img
initrd booster-linux.img
options root=UUID=$(blkid "${PARTITIONS[1]}" -s UUID -o value) rw quiet" > /mnt/boot/loader/entries/arch.conf
elif test "${DUALBOOT,,}" = "n"; then
    mkfs.fat -F 32 "${PARTITIONS[0]}" > /dev/null

    mkfs.ext4 -q "${PARTITIONS[1]}"

    mount "${PARTITIONS[1]}" /mnt

    mount -m -o fmask=0077,dmask=0077 "${PARTITIONS[0]}" /mnt/boot
    
    read -r -p "Install linux-firmware? [y/n]: " FIRMWARE

    if test "${FIRMWARE,,}" = "y"; then
        PKGS+=("iwd" "wireless-regdb" "linux-firmware")
    fi

    pacstrap -K /mnt "${PKGS[@]}"

    ln -s /usr/share/zoneinfo/America/Fortaleza /mnt/etc/localtime

    bootctl install --esp-path=/mnt/boot > /dev/null
    
    echo "title Arch Linux
linux vmlinuz-linux
initrd intel-ucode.img
initrd booster-linux.img
options root=UUID=$(blkid "${PARTITIONS[1]}" -s UUID -o value) rw quiet" > /mnt/boot/loader/entries/arch.conf
else
    return 1
fi

read -rp "Enter username: " NAME && clear

useradd -m -R /mnt -G wheel "$NAME"

passwd -R /mnt "$NAME" && clear

genstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt systemctl -q enable dhcpcd systemd-boot-update

arch-chroot /mnt systemctl -q disable systemd-userdbd.socket

if test "${FIRMWARE,,}" = "y"; then
    arch-chroot /mnt systemctl -q enable iwd

    mkdir /mnt/etc/iwd

    echo "[General]
AddressRandomization=once
AddressRandomizationRange=full" > /mnt/etc/iwd/main.conf
fi

echo "arch" > /mnt/etc/hostname

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

echo "KEYMAP=br-abnt2" > /mnt/etc/vconsole.conf

echo "$NAME ALL=(ALL:ALL) ALL" > /mnt/etc/sudoers.d/sudoers

echo "[zram0]
compression-algorithm = zstd" > /mnt/etc/systemd/zram-generator.conf

umount -R /mnt
