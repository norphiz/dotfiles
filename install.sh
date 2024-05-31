#!/usr/bin/env bash

set -eu

PKG_ARRAY=(
    base
    git
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

read -r -p 'Format the uefi partition? [N/y]: ' FORMAT_ANSWER

case "$FORMAT_ANSWER" in
    [yY]) mkfs.fat -F 32 -n UEFI "$UEFI" ;;
    [nN]) true ;;
    *) true ;;
esac

clear

mount "$ROOT" /mnt

mount -m "$BOOT" /mnt/boot

mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

reflector -c ',BR' -p https -f 5 --sort rate --save /etc/pacman.d/mirrorlist

printf 'Packages to be installed: %s\n' "${PKG_ARRAY[@]}"

read -r -p 'Enter extra packages to be installed: ' EXTRA_PKGS

PKG_ARRAY+=("$EXTRA_PKGS")

pacstrap -K /mnt "${PKG_ARRAY[@]}"

clear

genfstab -U /mnt >> /mnt/etc/fstab

read -r -p 'Enter hostname: ' HUNAME

sed 's/#en_US.UTF-8/en_US.UTF-8/' -i /mnt/etc/locale.gen

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

locale-gen

if test "$(command -v iwd)"
then
    systemctl -q enable iwd
    mkdir /etc/iwd
    echo '[Network]
NameResolvingService=resolvconf' > /etc/iwd/main.conf
fi

systemctl -q enable {dhcpcd,systemd-boot-update}

bootctl install

echo 'timeout 0
editor no
default arch' > /efi/loader/loader.conf

echo 'title Arch Linux
linux vmlinuz-linux
initrd intel-ucode.img
initrd booster-linux.img
options root=LABEL=ROOT rw quiet loglevel=0' > /boot/loader/entries/arch.conf

git clone -q --depth 1 https://github.com/norphiz/dotfiles.git "/home/$UNAME/.config"

git clone -q --depth 1 https://github.com/dracula/wallpaper.git "/home/$UNAME/.local/share/wallpaper"

git clone -q --depth 1 https://github.com/dracula/vim.git "/home/$UNAME/.config/nvim/pack/plugins/start/vim"

git clone -q --depth 1 https://github.com/echasnovski/mini.nvim.git "/home/$UNAME/.config/nvim/pack/plugins/start/mini.nvim"

git clone -q --depth 1 https://github.com/nvim-treesitter/nvim-treesitter.git "/home/$UNAME/.config/nvim/pack/plugins/start/nvim-treesitter"

echo 'Successfully installed.'

rm "$0"
