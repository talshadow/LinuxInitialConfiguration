#/bin/bash

sudo apt update
sudo apt purge firefox -y
pkcon update
sudo apt install gcc g++ clang clang-format clang-tidy lldb gdb cmake klog cmake-format ninja-build autoconf automake libtool flex bison gdb build-essential git libreoffice kdiff3 meld nano p7zip silversearcher-ag htop gpm unzip inetutils-traceroute heaptrack valgrind thunderbird silversearcher-ag okular-extra-backends libbenchmark-dev -y

#sudo dpkg-divert --rename --divert /etc/apt/apt.conf.d/20apt-esm-hook.conf.disabled --add /etc/apt/apt.conf.d/20apt-esm-hook.conf

pushd /tmp
TTFS=PkgTTF-IosevkaFixedSS08-33.2.0.zip
wget https://github.com/be5invis/Iosevka/releases/download/v33.2.0/{$TTFS}
unzip -d ./IosevkaFixedSS08 {$TTFS}
sudo cp -r ./IosevkaFixedSS08 /usr/share/fonts/truetype/
fc-cache -f -v
popd

pushd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb -y
sudo apt --fix-broken install -y
popd


#install video drivers for nvidia
# sudo ubuntu-drivers install --gpgpu --recommended --include-dkms
# sudo apt --fix-broken install
#or
# sudo apt install nvidia-driver-550 -y
# sudo apt --fix-broken install -y

pushd /tmp
wget https://download.qt.io/official_releases/online_installers/qt-online-installer-linux-x64-online.run
chmod +x ./qt-online-installer-linux-x64-online.run
sudo ./qt-online-installer-linux-x64-online.run
popd
