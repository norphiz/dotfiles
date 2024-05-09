#!/usr/bin/env bash

set -eu

cfdisk

clear

read -r -p 'Enter the esp partition: ' ESP

read -r -p 'Enter the boot partition: ' BOOT

read -r -p 'Enter the swap partition: ' SWAP

read -r -p 'Enter the root partition: ' ROOT

clear

mkfs.fat -F 32 "$ESP" > /dev/null 2>&1

mkswap "$SWAP" > /dev/null 2>&1

swapon "$SWAP"

mkfs.ext4 -L ROOT "$ROOT" > /dev/null 2>&1

mkfs.ext4 "$BOOT" > /dev/null 2>&1

mount "$ROOT" /mnt

mount -m "$ESP" /mnt/efi

reflector -c ',BR' -p https -f 5 --sort age --save /etc/pacman.d/mirrorlist

clear

pacstrap -K /mnt base iwd sudo dhcpcd xcursor-vanilla-dmz linux{,-firmware}

clear

cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

mount "$BOOT" /boot

genfstab -U /mnt >> /mnt/etc/fstab

read -r -p 'Enter hostname: ' HNAME

clear

sed -i 's/#en_US/en_US/' /mnt/etc/locale.gen

mkdir -p /mnt/etc/iwd

echo "$HNAME" > /mnt/etc/hostname

echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

echo 'KEYMAP=br-abnt2' > /mnt/etc/vconsole.conf

echo '%wheel ALL=(ALL:ALL) ALL' > /mnt/etc/sudoers.d/sudoers

echo '[General]
AddressRandomization=once
AddressRandomizationRange=full

[Network]
NameResolvingService=resolvconf

# vi: ft=dosini' > /etc/iwd/main.conf

sed -e 's/rel/noa/' \
    -e 's/fmask=0022/fmask=0137/' \
    -e 's/dmask=0022/dmask=0027/' -i /mnt/etc/fstab

sed -n '/^#chroot/,$p' "$0" > /mnt/chroot.sh

arch-chroot /mnt bash chroot.sh

#chroot

read -r -p 'Enter your username: ' UNAME

clear

useradd -mG wheel,audio,video "$UNAME"

passwd "$UNAME"

locale-gen > /dev/null 2>&1

systemctl enable {iwd,dhcpcd,systemd-boot-update} > /dev/null

bootctl install > /dev/null 2>&1

echo 'timeout 0
editor no
default arch' > /boot/loader/loader.conf

echo 'title Arch Linux
linux vmlinuz-linux
initrd intel-ucode.img
initrd booster-linux.img
options root=LABEL=ROOT rw quiet loglevel=0' > /boot/loader/entries/arch.conf

echo 'Successfully installed.'

rm "$0"
