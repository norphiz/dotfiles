#!/bin/bash

set -eu

main()
{
    lsblk -f
    
    local UEFI BOOT SWAP ROOT ANSWER

    read -r -p 'Enter the uefi partition: ' UEFI
    
    read -r -p 'Enter the boot partition: ' BOOT

    read -r -p 'Enter the swap partition: ' SWAP

    read -r -p 'Enter the root partition: ' ROOT

    clear

    mkfs.fat -F 32 -n BOOT "$BOOT" > /dev/null

    mkswap -q -L SWAP "$SWAP"

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

    pacstrap -G -K -M /mnt base > /dev/null 2>&1

    mount -m "$BOOT" /mnt/boot

    mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

    genfstab -U /mnt >> /mnt/etc/fstab

    sed 's/rel/no/' -i /mnt/etc/fstab

    read -r -p 'Enter hostname: ' ANSWER

    clear

    echo "$ANSWER" > /mnt/etc/hostname

    echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

    echo 'FONT=ter-128b
    KEYMAP=br-abnt2' > /mnt/etc/vconsole.conf

    bootctl -q --esp-path=/mnt/efi --boot-path=/mnt/boot install

    echo 'editor no
    timeout 10' > /mnt/efi/loader/loader.conf

    echo 'title Arch Linux
    linux vmlinuz-linux
    initrd intel-ucode.img
    initrd booster-linux.img
    options root=LABEL=ROOT rw' > /mnt/boot/loader/entries/arch.conf
    
    sed -n '92,$p' "$0" > /mnt/chroot.sh

    arch-chroot /mnt bash chroot.sh
}

main

#!/bin/bash

set -eu

after_chroot()
{   
    local PACKAGES NAME EXTRA

    PACKAGES=(
        sudo
        linux
        dhcpcd
        booster
        intel-ucode
        glibc-locales
        linux-firmware
    )

    echo "Packages to be installed: ${PACKAGES[*]}"

    read -r -p 'Enter extra packages to be installed: ' -a EXTRA

    clear

    PACKAGES+=("${EXTRA[@]}")

    pacman -S --noconfirm "${PACKAGES[@]}"

    clear
    
    echo '%wheel ALL=(ALL:ALL) ALL' > /mnt/etc/sudoers.d/sudoers
    
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

    echo 'Successfully installed.'

    rm "$0"
}

after_chroot

exit
