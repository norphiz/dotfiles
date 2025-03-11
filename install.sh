#!/bin/bash

set -eu

lsblk

read -r -p 'Enter the uefi partition: ' UEFI

read -r -p 'Enter the root partition: ' ROOT

mkfs.ext4 -q "$ROOT"

mount "$ROOT" /mnt

pacstrap -K /mnt base

clear

while true
do
    read -r -p 'Are you dual booting? [N/y]: ' DUAL

    case "$DUAL" in
        [yY])
            lsblk

            read -r -p 'Enter boot partition: ' BOOT

            mkfs.fat -F 32 "$BOOT"

            mount "$BOOT" /mnt/boot

            mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

            bootctl -q --esp-path=/mnt/efi --boot-path=/mnt/boot install
            
            echo 'editor no
            timeout 10' > /mnt/efi/loader/loader.conf

            echo "title Arch Linux
            linux vmlinuz-linux
            initrd intel-ucode.img
            initrd booster-linux.img
            options root=$(blkid "$ROOT" | awk '{print $2}') rw" > /mnt/boot/loader/entries/arch.conf

            clear

            break ;;
        [nN])
            mkfs.fat -F 32 "$UEFI"

            mount -o fmask=0077,dmask=0077 "$UEFI" /mnt/boot

            bootctl -q --esp-path=/mnt/boot install

            echo "title Arch Linux
            linux vmlinuz-linux
            initrd intel-ucode.img
            initrd booster-linux.img
            options root=$(blkid "$ROOT" | awk '{print $2}') rw" > /mnt/boot/loader/entries/arch.conf

            clear

            break ;;
    esac
done

genfstab -U /mnt >> /mnt/etc/fstab

echo 'arch' > /mnt/etc/hostname

echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

echo 'KEYMAP=br-abnt2' > /mnt/etc/vconsole.conf

echo '[zram0]
compression-algorithm = zstd' > /mnt/etc/systemd/zram-generator.conf

sed -n '85,$p' "$0" > /mnt/chroot.sh

arch-chroot /mnt bash chroot.sh

exit

#!/bin/bash

set -eu

PACKAGES=(
    sudo
    linux
    dhcpcd
    xdg-utils
    intel-ucode
    glibc-locales
    xdg-user-dirs
    linux-firmware
    zram-generator
)

ln -s /usr/share/zoneinfo/America/Fortaleza /etc/localtime

echo "Packages to be installed: ${PACKAGES[*]}"

read -r -p 'Enter extra packages to be installed: ' -a EXTRA

clear

PACKAGES+=("${EXTRA[@]}")

pacman -S "${PACKAGES[@]}"

clear

read -r -p 'Enter username: ' NAME

clear

useradd -m -G wheel "$NAME"

passwd "$NAME"

clear

echo "$NAME ALL=(ALL:ALL) ALL" > /etc/sudoers.d/sudoers

systemctl -q enable dhcpcd systemd-boot-update

systemctl -q disable systemd-userdbd.socket

if test -e /usr/bin/iwctl
then
    systemctl -q enable iwd

    mkdir /etc/iwd

    echo '[General]
AlwaysRandomizeAddress=true

[Network]
NameResolvingService=resolvconf' > /etc/iwd/main.conf
fi

rm "$0"

exit
