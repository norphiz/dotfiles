#!/bin/bash

set -eu

lsblk -f

read -r -p 'Enter the uefi partition: ' UEFI

read -r -p 'Enter the boot partition: ' BOOT

read -r -p 'Enter the swap partition: ' SWAP

read -r -p 'Enter the root partition: ' ROOT

clear

mkfs.fat -F 32 "$BOOT" > /dev/null

mkswap -q "$SWAP"

swapon "$SWAP"

mkfs.ext4 -q -L ROOT "$ROOT"

while true
do
    read -r -p 'Format the uefi partition? [N/y]: ' ANSWER

    case "$ANSWER" in
        [yY])
            mkfs.fat -F 32 -n UEFI "$UEFI" > /dev/null

            clear

            break

            ;;
        [nN])
            clear

            break

            ;;
    esac
done

mount "$ROOT" /mnt

pacstrap -K /mnt base sudo dhcpcd booster glibc-locales \
    linux-firmware terminus-font > /dev/null 2>&1

mount -m "$BOOT" /mnt/boot

mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

genfstab -U /mnt >> /mnt/etc/fstab

read -r -p 'Enter hostname: ' ANSWER

clear

echo "$ANSWER" > /mnt/etc/hostname

echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

echo 'FONT=ter-128b
KEYMAP=br-abnt2' > /mnt/etc/vconsole.conf

echo '%wheel ALL=(ALL:ALL) ALL' > /mnt/etc/sudoers.d/sudoers

bootctl install --esp-path=/mnt/efi --boot-path=/mnt/boot > /dev/null 2>&1

echo 'editor no
timeout 10' > /mnt/efi/loader/loader.conf

echo 'title Arch Linux
linux vmlinuz-linux
initrd intel-ucode.img
initrd booster-linux.img
options root=LABEL=ROOT rw' > /mnt/boot/loader/entries/arch.conf

sed -n '86,$p' "$0" > /mnt/chroot.sh

arch-chroot /mnt bash chroot.sh

#!/bin/bash

set -eu

PACKAGES=(
    linux
    intel-ucode
)

echo "Packages to be installed: ${PACKAGES[*]}"

read -r -p 'Enter extra packages to be installed: ' -a EXTRA

clear

PACKAGES+=("${EXTRA[@]}")

pacman -S --noconfirm "${PACKAGES[@]}" > /dev/null

read -r -p 'Enter username: ' NAME

clear

useradd -m -G wheel,audio,video "$NAME"

passwd "$NAME"

clear

if test "$(command -v iwctl)"
then
    mkdir /etc/iwd

    echo '[Network]
    NameResolvingService=resolvconf' >> /etc/iwd/main.conf

    systemctl -q enable iwd
fi

systemctl -q enable dhcpcd systemd-boot-update

rm "$0"

exit
