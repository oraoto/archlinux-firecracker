#!/usr/bin/env bash

fallocate -l 4G /output/arch-rootfs.ext4
mkfs.ext4 /output/arch-rootfs.ext4

mkdir -p arch
mount /output/arch-rootfs.ext4 arch

echo "Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
pacstrap -i -c $(readlink -f arch) bash filesystem systemd-sysvcompat pacman iproute2

echo "nameserver 114.114.114.114" > arch/etc/resolv.conf

tee arch/etc/systemd/system/firecracker-network.service <<-'EOF'
[Unit]
Description=Firecracker Network

[Service]
Type=oneshot
ExecStart=ip link set eth0 up
ExecStart=ip addr add 172.16.0.2/24 dev eth0
ExecStart=ip route add default via 172.16.0.1 dev eth0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

ln -s /etc/systemd/system/firecracker-network.service arch/etc/systemd/system/multi-user.target.wants/

umount -R arch

rmdir arch
