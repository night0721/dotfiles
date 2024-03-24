#!/bin/sh

efipart=$(awk -F' ' '{print $1}' /dotparts)
windowspart=$(awk -F' ' '{print $2}' /dotparts)

nightpasswd=$(awk -F' ' '{print $1}' /dotpass)

# clear the screen
clear

cd /home/night
pacman -Syu --noconfirm > /dev/null

### Install all of the above pacakges ####
sudo pacman -S --needed bluez brightnessctl btop chafa connman dos2unix firefox foot grim \
    hugo imagemagick iwd lf libgit2 libnotify libsodium libwebsockets mako mandoc mpv ncdu \
    neovim newsboat noto-fonts-emoji npm ntfs-3g nvidia-open openssh pass pipewire-pulse \
    python-mutagen slurp socat swappy wf-recorder wireplumber wlroots wl-clipboard xdg-desktop-portal-wlr yt-dlp zathura-pdf-poppler --noconfirm > /dev/null

# update config
sudo sed -i 's/MODULES=()/MODULES=(amdgpu nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
# sudo sed -i 's/MODULES=()/MODULES=(vfio vfio_iommu_type1 vfio_pci amdgpu nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf # for qemu passthrough
# sudo sed -i '/^HOOKS=/ s/udev/& plymouth/' /etc/mkinitcpio.conf
sudo mkinitcpio -p linux --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
echo -e "blacklist nouveau\noptions nvidia_drm modeset=1 fbdev=1" | sudo tee -a /etc/modprobe.d/nvidia.conf


sudo systemctl enable --now bluetooth
sleep 2

### Copy Config Files ###
cp -R /dotfiles/.config /dotfiles/.local /dotfiles/.npmrc /dotfiles/.github /dotfiles/.gitignore /dotfiles/.data /home/night/

# /etc/hosts
cd /dotfiles/.data/misc
curl -L -O https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
sudo cp hosts /etc/hosts

# autojump
cd /home/night
git clone https://github.com/wting/autojump.git
cd autojump
./install.py

# suckless stuff
cd ~
mkdir repos
cd repos
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
cd ble.sh
make -C ble.sh install PREFIX=~/.local
cd ..
git clone https://github.com/night0721/aureate
cd aureate
make
sudo make install
cd ..
git clone https://codeberg.org/dwl/dwl
cd dwl
git switch wlroots-next
patch < ~/.data/patches/dwl.patch
mv dwl-ipc-unstable-v2.xml protocols
make 
sudo make install
cd ..
git clone https://codeberg.org/night0721/dwlb
cd dwlb
sudo make install
cd ..
git clone https://codeberg.org/night0721/someblocks
cd someblocks
sudo make install
cd ..
git clone https://codeberg.org/night0721/wbg
cd wbg
meson --buildtype=release build
ninja -C build
sudo ninja -C build install
cd ..
git clone https://github.com/night0721/fnf
cd fnf
make
sudo make install
cd ..
git clone https://github.com/night0721/sloc
cd sloc
make
sudo make install
cd ..
git clone https://github.com/night0721/kat
cd kat
make
sudo mv kat /usr/local/bin
cd ..
git clone https://github.com/night0721/nvimpager
cd nvimpager
make PREFIX=$HOME/.local install
cd ..

# bash
ln -sf /home/night/.config/sh/.bashrc /home/night/.bashrc

# plymouth
# cd /usr/share/plymouth/themes/
# sudo git clone https://github.com/farsil/monoarch > /dev/null
# sudo plymouth-set-default-theme -R monoarch > /dev/null
# cd monoarch
# sudo rm -rf .git LICENSE README.md

# grub
cd /dotfiles
sudo cp .data/misc/grub /etc/default/grub
sudo mkdir -p /boot/grub/themes
sudo cp -r .data/misc/n /boot/grub/themes/n
sudo grub-install —-target=x86_64-efi --efi-directory=/boot/efi —-bootloader-id=Arch —-recheck
sudo grub-mkconfig -o /boot/grub/grub.cfg

# misc
sudo sed -i "s/dmenu-wl/wmenu" /usr/bin/passmenu # fix passmenu not using wmenu
sudo sed -i "s/\"\$dmenu\"/\"\$dmenu\" -i -p 'Password' -f 'MonaspiceKr Nerd Font 13' -N 1e1e2e -n cdd6f4 -M 1e1e2e -m f38ba8 -S 1e1e2e -s f9e2af/" /usr/bin/passmenu
sudo rm -rf /usr/share/doc /usr/share/licenses /usr/share/gtk-doc /usr/lib/node_modules/npm/docs
sudo find /usr/share/fonts/adobe-source-han-sans -type f ! -name "SourceHanSansHK-Normal.otf" -delete
sudo find / -type f -name "*.md" -print -mount
sudo find / -type f -name "LICENSE" -print -mount

echo -e 'root ALL=(ALL:ALL) ALL
n ALL=(ALL:ALL) ALL
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
@includedir /etc/sudoers.d' | sudo tee -a /etc/sudoers

cd ~
mkdir fonts
curl -L -O https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
curl -L -O https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Monaspace.zip
unzip Monaspace.zip
unzip JetBrainsMono.zip
sudo mkdir /usr/share/fonts/TTF
sudo mv MonaspiceKrNerdFont-*.otf /usr/share/fonts/TTF
sudo mv JetBrainsMonoNerdFont* /usr/share/fonts/TTF
cd ..
rm -rf fonts

sudo mv /usr/share/fonts/adobe-source-han-sans/SourceHanSansHK-Normal.otf /usr/share/fonts/TTF
sudo pacman -Rcns dobe-source-han-sans-hk-fonts

printf "$nightpasswd\n" | chsh -s /usr/bin/bash

sudo usermod -aG wheel,storage,power,lp,input,disk,audio,video night
# sudo usermod -aG wheel,storage,power,lp,libvirt,kvm,libvirt-qemu,input,disk,audio,video night # with qemu
sudo systemctl enable --now connman iwd 
echo "Install finished, type 'reboot'"

# void https://github.com/elbachir-one/dotfiles/blob/main/install.sh
