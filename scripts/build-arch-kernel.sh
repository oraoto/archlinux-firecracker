#!/usr/bin/env bash

KERNEL_VERSION=4.20.3

mkdir -p /build

cd /build

## Install build tools
echo "Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlis
pacman -Syu --noconfirm base-devel bc --ignore linux-firmware

## Get kernel source
curl -o linux.tar.xz "https://mirrors.tuna.tsinghua.edu.cn/kernel/v4.x/linux-$KERNEL_VERSION.tar.xz"
tar xf linux.tar.xz
cd linux-$KERNEL_VERSION/

## Get Archlinux kernel config
curl -o .config https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux

## Disable modules
sed 's/\(.*\)=m/#\1 is not set/g' -i .config
sed 's/\(.*\)MOUSE\(.*\)=y/\1MOUSE\2=n/g' -i .config
sed 's/\(.*\)USB\(.*\)=y/\1USB\2=n/g' -i .config
sed 's/\(.*\)TOUCHSCREEN\(.*\)=y/\1TOUCHSCREEN\2=n/g' -i .config
sed 's/\(.*\)HID\(.*\)=y/\1HID\2=n/g' -i .config
sed 's/\(.*\)GPU\(.*\)=y/\1GPU\2=n/g' -i .config
sed 's/\(.*\)GPIO\(.*\)=y/\1GPIO\2=n/g' -i .config
sed 's/\(.*\)NVDIMM\(.*\)=y/\1NVDIMM\2=n/g' -i .config
sed 's/\(.*\)MFD\(.*\)=y/\1MFD\2=n/g' -i .config
sed 's/\(.*\)XEN\(.*\)=y/\1XEN\2=n/g' -i .config
sed 's/\(.*\)VIDEO\(.*\)=y/\1VIDEO\2=n/g' -i .config
sed 's/\(.*\)PCI\(.*\)=y/\1PCI\2=n/g' -i .config
sed 's/\(.*\)WLAN\(.*\)=y/\1WLAN\2=n/g' -i .config

## Add Virtio and filesystem back
cat /config/virtio.config >> .config
cat /config/fs.config >> .config

yes '' | make -j4

./scripts/extract-vmlinux ./arch/x86_64/boot/bzImage > /output/arch-vmlinux.bin
