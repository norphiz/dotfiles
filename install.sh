#!/usr/bin/env bash

set -eu

PKG_ARRAY=(
    base
    glibc-locales
    sudo
    dhcpcd
    booster
    linux
    intel-ucode
    linux-firmware
)

cfdisk

clear

lsblk

read -r -p 'Enter the uefi partition: ' UEFI

read -r -p 'Enter the boot partition: ' BOOT

read -r -p 'Enter the swap partition: ' SWAP

read -r -p 'Enter the root partition: ' ROOT

mkfs.fat -F 32 -n XBOOTLDR "$BOOT"

mkswap -L SWAP "$SWAP"

swapon "$SWAP"

mkfs.ext4 -L ROOT "$ROOT"

while true; do
    read -r -p 'Format the uefi partition? [N/y]: ' FORMAT_ANSWER
    case "$FORMAT_ANSWER" in
        [yY]) mkfs.fat -F 32 -n UEFI "$UEFI" && break ;;
        [nN]) break ;;
    esac
done

clear

mount "$ROOT" /mnt

mount -m "$BOOT" /mnt/boot

mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

echo "Packages to be installed: ${PKG_ARRAY[*]}"

read -r -p 'Enter extra packages to be installed: ' EXTRA_PKGS

PKG_ARRAY+=("$EXTRA_PKGS")

pacstrap -i -K /mnt "${PKG_ARRAY[@]}"

clear

genfstab -U /mnt >> /mnt/etc/fstab

read -r -p 'Enter hostname: ' HUNAME

echo "$HUNAME" > /mnt/etc/hostname

echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

echo 'KEYMAP=br-abnt2' > /mnt/etc/vconsole.conf

echo '%wheel ALL=(ALL:ALL) ALL' > /mnt/etc/sudoers.d/sudoers

sed 's/rel/no/' -i /mnt/etc/fstab

sed -n '/^#chroot/,$p' "$0" > /mnt/chroot.sh

arch-chroot /mnt bash chroot.sh

#chroot

read -r -p 'Enter your username: ' UNAME

useradd -mG wheel,audio,video "$UNAME"

passwd "$UNAME"

if test "$(command -v iwd)"; then
    systemctl -q enable iwd
    mkdir /etc/iwd
    echo '[Network]
NameResolvingService=resolvconf' > /etc/iwd/main.conf
fi

systemctl -q enable dhcpcd systemd-boot-update

bootctl install

echo 'timeout 10
editor no
default arch' > /efi/loader/loader.conf

echo 'title Arch Linux
linux vmlinuz-linux
initrd intel-ucode.img
initrd booster-linux.img
options root=LABEL=ROOT rw quiet' > /boot/loader/entries/arch.conf

echo 'Successfully installed.'

rm "$0"
