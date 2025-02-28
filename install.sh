#!/bin/bash

set -eu

lsblk -f

read -r -p 'Enter the uefi partition: ' UEFI

read -r -p 'Enter the swap partition: ' SWAP

read -r -p 'Enter the root partition: ' ROOT

mkfs.ext4 -q -L ROOT "$ROOT"

mkswap -q "$SWAP"

swapon "$SWAP"

mount "$ROOT" /mnt

pacstrap -K /mnt base sudo dhcpcd booster glibc-locales \
    linux-firmware terminus-font

while true
do
    read -r -p 'Are you dual booting? [N/y]: ' DUAL

    case "$DUAL" in
        [yY])
            lsblk -f

            read -r -p 'Enter boot partition: ' BOOT

            clear

            mount -m "$BOOT" /mnt/boot

            mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

            bootctl --esp-path=/mnt/efi --boot-path=/mnt/boot install

            ;;
        [nN])
            mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/boot

            bootctl --esp-path=/mnt/boot install

            clear

            break

            ;;
    esac
done

genfstab -U /mnt >> /mnt/etc/fstab

read -r -p 'Enter hostname: ' ANSWER

clear

echo "$ANSWER" > /mnt/etc/hostname

echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

echo 'FONT=ter-128b
KEYMAP=br-abnt2' > /mnt/etc/vconsole.conf

echo 'editor no
timeout 10' > /mnt/efi/loader/loader.conf

echo 'title Arch Linux
linux vmlinuz-linux
initrd intel-ucode.img
initrd booster-linux.img
options root=LABEL=ROOT rw' > /mnt/boot/loader/entries/arch.conf

sed -n '84,$p' "$0" > /mnt/chroot.sh

arch-chroot /mnt bash chroot.sh

exit

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

pacman -S --noconfirm "${PACKAGES[@]}"

clear

read -r -p 'Enter username: ' NAME

clear

useradd -m "$NAME"

passwd "$NAME"

echo "$NAME ALL=(ALL:ALL) ALL" > /etc/sudoers.d/sudoers

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
