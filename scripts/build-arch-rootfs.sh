#!/usr/bin/env bash

DISK_SIZE=4G
DISK_FILE=../output/arch-rootfs.ext4
DISK_ROOT=../output/mount

cd $(dirname "${BASH_SOURCE[0]}")

# Allocate rootfs disk
fallocate -l 4G $DISK_FILE
mkfs.ext4 $DISK_FILE

# Mount rootfs to mount
mkdir -p $DISK_ROOT

sudo mount $DISK_FILE $DISK_ROOT

yes y | sudo pacstrap -i -c $DISK_ROOT bash filesystem systemd-sysvcompat pacman iproute2

echo "nameserver 1.1.1.1" | sudo tee $DISK_ROOT/etc/resolv.conf

sudo tee $DISK_ROOT/etc/systemd/system/firecracker-network.service <<-'EOF'
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

sudo ln -s /etc/systemd/system/firecracker-network.service $DISK_ROOT/etc/systemd/system/multi-user.target.wants/

# Remove default (locked) root password
# See https://github.com/archlinux/svntogit-packages/commit/0320c909f3867d47576083e853543bab1705185b

sudo sed 's/^root:.*/root::14871::::::/' -i $DISK_ROOT/etc/shadow

sudo umount $DISK_ROOT
rmdir $DISK_ROOT
