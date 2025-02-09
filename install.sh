#!/usr/bin/env bash

set -eu

main() {

    cfdisk

    clear

    lsblk
    
    local UEFI BOOT SWAP ROOT ANSWER PACKAGES

    read -r -p 'Enter the uefi partition: ' UEFI
    
    read -r -p 'Enter the boot partition: ' BOOT

    read -r -p 'Enter the swap partition: ' SWAP

    read -r -p 'Enter the root partition: ' ROOT

    mkfs.fat -F 32 -n BOOT "$BOOT"

    clear

    mkswap -q -L SWAP "$SWAP"

    swapon "$SWAP"

    mkfs.ext4 -q -L ROOT "$ROOT"

    while true
    do
        read -r -p 'Format the uefi partition? [N/y]: ' ANSWER

        case "$ANSWER" in
            [yY])
                mkfs.fat -F 32 -n UEFI "$UEFI"
                
                break
                
                ;;
            [nN])
                break
                
                ;;
        esac
    done

    mount "$ROOT" /mnt

    mount -m "$BOOT" /mnt/boot

    mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

    PACKAGES=(terminus-font glibc-locales sudo dhcpcd linux-firmware)

    echo "Packages to be installed: ${PACKAGES[*]}"

    read -r -p 'Enter extra packages to be installed: ' -a EXTRA

    PACKAGES+=("${EXTRA[@]}")

    pacstrap -K /mnt base booster linux intel-ucode "${PACKAGES[@]}"
    
    genfstab -U /mnt >> /mnt/etc/fstab

    sed 's/rel/no/' -i /mnt/etc/fstab

    local HOSTNAME

    read -r -p 'Enter hostname: ' HOSTNAME

    echo "$HOSTNAME" > /mnt/etc/hostname

    echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

    echo 'FONT=ter-128b
    KEYMAP=br-abnt2' > /mnt/etc/vconsole.conf

    echo '%wheel ALL=(ALL:ALL) ALL' > /mnt/etc/sudoers.d/sudoers
    
    bootctl -q --esp-path=/mnt/efi --boot-path=/mnt/boot install

    echo 'editor no
    timeout 10' > /mnt/efi/loader/loader.conf

    echo 'title Arch Linux
    linux vmlinuz-linux
    initrd intel-ucode.img
    initrd booster-linux.img
    options root=LABEL=ROOT rw' > /mnt/boot/loader/entries/arch.conf
    
    sed -n '102,$p' "$0" > /mnt/tmp/chroot.sh

    arch-chroot /mnt bash /tmp/chroot.sh
}

main

#!/usr/bin/env bash

set -eu

after_chroot() {

    local NAME

    read -r -p 'Enter username' NAME

    useradd -m -G wheel,audio,video "$NAME"

    passwd "$NAME"

    if test "$(command -v iwctl)"
    then
        mkdir /etc/iwd

        echo '[Network]
        NameResolvingService=resolvconf' >> /etc/iwd/main.conf

        systemctl -q enable iwd
    fi

    systemctl -q enable dhcpcd systemd-boot-update

    echo 'Successfully installed.'
}

after_chroot
