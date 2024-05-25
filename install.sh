#!/usr/bin/env bash

set -eu

cfdisk

clear

read -r -p 'Enter the uefi partition: ' UEFI

read -r -p 'Enter the boot partition: ' BOOT

read -r -p 'Enter the swap partition: ' SWAP

read -r -p 'Enter the root partition: ' ROOT

mkfs.fat -F 32 "$UEFI"

mkfs.fat -F 32 "$BOOT"

mkswap "$SWAP"

swapon "$SWAP"

mkfs.ext4 -L ROOT "$ROOT"

mount "$ROOT" /mnt

mount -m "$BOOT" /mnt/boot

mount -m -o fmask=0077,dmask=0077 "$UEFI" /mnt/efi

reflector -c 'BR,' -p https -f 5 --sort age --save /etc/pacman.d/mirrorlist

pacstrap -i -K /mnt base iwd intel-ucode git sudo dhcpcd linux{,-firmware}

clear

genfstab -U /mnt >> /mnt/etc/fstab

read -r -p 'Enter hostname: ' HNAME

sed 's/#en_US.UTF-8/en_US.UTF-8/' -i /mnt/etc/locale.gen

mkdir /mnt/etc/iwd

echo "$HNAME" > /mnt/etc/hostname

echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

echo 'KEYMAP=br-abnt2' > /mnt/etc/vconsole.conf

echo '%wheel ALL=(ALL:ALL) ALL' > /mnt/etc/sudoers.d/sudoers

echo '[Network]
NameResolvingService=resolvconf

# vi: ft=dosini' > /etc/iwd/main.conf

sed 's/rel/no/' -i /mnt/etc/fstab

sed -n '/^#chroot/,$p' "$0" > /mnt/chroot.sh

arch-chroot /mnt bash chroot.sh

#chroot

read -r -p 'Enter your username: ' UNAME

useradd -mG wheel,audio,video "$UNAME"

passwd "$UNAME"

locale-gen

systemctl -q enable {iwd,dhcpcd,systemd-boot-update}

bootctl install

echo 'timeout 0
editor no
default arch' > /efi/loader/loader.conf

echo 'title Arch Linux
linux vmlinuz-linux
initrd intel-ucode.img
initrd booster-linux.img
options root=LABEL=ROOT rw quiet loglevel=0' > /boot/loader/entries/arch.conf

git clone -q --depth 1 https://github.com/norphiz/dotfiles.git "/home/$NAME/.config"

git clone -q --depth 1 https://github.com/dracula/wallpaper.git "/home/$NAME/.local/share/wallpaper"

git clone -q --depth 1 https://github.com/dracula/vim.git "/home/$NAME/.config/nvim/pack/plugins/start/dracula.vim"

git clone -q --depth 1 https://github.com/windwp/nvim-autopairs.git "/home/$NAME/.config/nvim/pack/plugins/start/nvim-autopairs"

git clone -q --depth 1 https://github.com/nvim-treesitter/nvim-treesitter.git "/home/$NAME/.config/nvim/pack/plugins/start/nvim-treesitter"

echo 'Successfully installed.'

rm "$0"
